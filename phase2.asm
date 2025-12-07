[org 0x100]
jmp Start

; --------------------------------
; Variables
; --------------------------------
player_row: dw 19
player_col: dw 34

obstacle1_row: dw 0
obstacle1_col: dw 23
obstacle1_active: db 1

obstacle2_row: dw 7
obstacle2_col: dw 34
obstacle2_active: db 1

obstacle3_row: dw 14
obstacle3_col: dw 45
obstacle3_active: db 1

coin_row: dw 4
coin_col: dw 25
coin_active: db 1

fuel_row: dw 15
fuel_col: dw 47
fuel_active: db 1

score: dw 0
fuel_level: dw 100
frame_count: dw 0
lane_scroll: dw 0
random_seed: dw 12345

; Game state variables
game_started: db 0
game_paused: db 0
show_confirmation: db 0
old_kbd_isr: dd 0

; --------------------------------
; xy_to_di
; --------------------------------
xy_to_di:
    push dx
    push bx
    mov dx, ax
    mov ax, 80
    mul dx
    pop bx
    add ax, bx
    shl ax, 1
    mov di, ax
    pop dx
    ret

; --------------------------------
; Draw Player Car (Red)
; --------------------------------
draw_player:
    push es
    push di
    push ax
    push bx
    
    mov ax, 0xb800
    mov es, ax
    
    mov ax, [player_row]
    mov bx, [player_col]
    
    call xy_to_di
    mov word [es:di], 0x70FE
    mov word [es:di+2], 0x4CDB
    mov word [es:di+4], 0x4CDB
    mov word [es:di+6], 0x70FE
    
    mov ax, [player_row]
    inc ax
    mov bx, [player_col]
    call xy_to_di
    mov word [es:di], 0x4CDB
    mov word [es:di+2], 0x08DB
    mov word [es:di+4], 0x08DB
    mov word [es:di+6], 0x4CDB
    
    mov ax, [player_row]
    add ax, 2
    mov bx, [player_col]
    call xy_to_di
    mov word [es:di], 0x70FE
    mov word [es:di+2], 0x4CDB
    mov word [es:di+4], 0x4CDB
    mov word [es:di+6], 0x70FE
    
    pop bx
    pop ax
    pop di
    pop es
    ret

; --------------------------------
; Draw Obstacle Car (Blue)
; --------------------------------
draw_obstacle:
    push es
    push di
    push cx
    
    mov cx, ax
    mov ax, 0xb800
    mov es, ax
    
    mov ax, cx
    call xy_to_di
    mov word [es:di], 0x70FE
    mov word [es:di+2], 0x19DB
    mov word [es:di+4], 0x19DB
    mov word [es:di+6], 0x70FE
    
    mov ax, cx
    inc ax
    call xy_to_di
    mov word [es:di], 0x19DB
    mov word [es:di+2], 0x08DB
    mov word [es:di+4], 0x08DB
    mov word [es:di+6], 0x19DB
    
    mov ax, cx
    add ax, 2
    call xy_to_di
    mov word [es:di], 0x70FE
    mov word [es:di+2], 0x19DB
    mov word [es:di+4], 0x19DB
    mov word [es:di+6], 0x70FE
    
    pop cx
    pop di
    pop es
    ret

; --------------------------------
; Clear Car
; --------------------------------
clear_car:
    push es
    push di
    push cx
    push dx
    
    mov cx, ax
    mov dx, bx
    mov ax, 0xb800
    mov es, ax
    
    mov bx, 0
.clear_loop:
    mov ax, cx
    add ax, bx
    push bx
    mov bx, dx
    call xy_to_di
    pop bx
    
    mov word [es:di], 0x7020
    mov word [es:di+2], 0x7020
    mov word [es:di+4], 0x7020
    mov word [es:di+6], 0x7020
    
    inc bx
    cmp bx, 3
    jl .clear_loop
    
    pop dx
    pop cx
    pop di
    pop es
    ret

; --------------------------------
; Draw Coin (spinning)
; --------------------------------
draw_coin:
    push es
    push di
    push cx
    
    push bx
    push ax
    mov ax, 0xb800
    mov es, ax
    pop ax
    pop bx
    
    call xy_to_di
    
    mov cx, [frame_count]
    shr cx, 2
    and cx, 3
    
    cmp cx, 0
    je .frame0
    cmp cx, 1
    je .frame1
    cmp cx, 2
    je .frame2
    jmp .frame3
    
.frame0:
    mov word [es:di], 0x7E28
    mov word [es:di+2], 0x7E24
    mov word [es:di+4], 0x7E29
    jmp .done
    
.frame1:
    mov word [es:di], 0x7E7C
    mov word [es:di+2], 0x7F24
    mov word [es:di+4], 0x7E7C
    jmp .done
    
.frame2:
    mov word [es:di], 0x7020
    mov word [es:di+2], 0x7EDB
    mov word [es:di+4], 0x7020
    jmp .done
    
.frame3:
    mov word [es:di], 0x7E7C
    mov word [es:di+2], 0x7F24
    mov word [es:di+4], 0x7E7C
    
.done:
    pop cx
    pop di
    pop es
    ret

; --------------------------------
; Draw Fuel Canister
; --------------------------------
draw_fuel:
    push es
    push di
    
    push bx
    push ax
    mov ax, 0xb800
    mov es, ax
    pop ax
    pop bx
    
    call xy_to_di
    mov word [es:di], 0x2F46      ; White F on green
    mov word [es:di+2], 0x2ADB    ; Green block
    
    pop di
    pop es
    ret

; --------------------------------
; Clear coin (3 chars)
; --------------------------------
clear_coin:
    push es
    push di
    
    push bx
    push ax
    mov ax, 0xb800
    mov es, ax
    pop ax
    pop bx
    
    call xy_to_di
    mov word [es:di], 0x7020
    mov word [es:di+2], 0x7020
    mov word [es:di+4], 0x7020
    
    pop di
    pop es
    ret

; --------------------------------
; Clear fuel (2 chars)
; --------------------------------
clear_fuel:
    push es
    push di
    
    push bx
    push ax
    mov ax, 0xb800
    mov es, ax
    pop ax
    pop bx
    
    call xy_to_di
    mov word [es:di], 0x7020
    mov word [es:di+2], 0x7020
    
    pop di
    pop es
    ret

; --------------------------------
; Draw Fuel Bar
; --------------------------------
draw_fuel_bar:
    push es
    push di
    push ax
    push bx
    push cx
    push dx
    
    mov ax, 0xb800
    mov es, ax
    
    ; Draw "FUEL" label
    mov ax, 2
    mov bx, 72
    call xy_to_di
    mov word [es:di], 0x2F46
    mov word [es:di+2], 0x2F55
    mov word [es:di+4], 0x2F45
    mov word [es:di+6], 0x2F4C
    
    ; Calculate filled portion
    mov ax, [fuel_level]
    xor dx, dx
    mov cx, 5
    div cx
    mov dx, ax
    
    ; Draw 20 rows of bar
    mov cx, 20
    mov bx, 4
.bar_loop:
    push cx
    push dx
    
    mov ax, bx
    push bx
    mov bx, 74
    call xy_to_di
    pop bx
    
    mov ax, 23
    sub ax, bx
    
    pop dx
    push dx
    
    cmp ax, dx
    jge .empty_row
    
    cmp dx, 14
    jge .green_bar
    cmp dx, 7
    jge .yellow_bar
    mov word [es:di], 0x4CDB
    mov word [es:di+2], 0x4CDB
    jmp .next_row
.green_bar:
    mov word [es:di], 0x2ADB
    mov word [es:di+2], 0x2ADB
    jmp .next_row
.yellow_bar:
    mov word [es:di], 0x6EDB
    mov word [es:di+2], 0x6EDB
    jmp .next_row
.empty_row:
    mov word [es:di], 0x0820
    mov word [es:di+2], 0x0820
    
.next_row:
    pop dx
    pop cx
    inc bx
    loop .bar_loop
    
    ; Draw bar border - top
    mov ax, 3
    mov bx, 73
    call xy_to_di
    mov word [es:di], 0x0FDA
    mov word [es:di+2], 0x0FC4
    mov word [es:di+4], 0x0FC4
    mov word [es:di+6], 0x0FBF
    
    ; Side borders
    mov cx, 20
    mov bx, 4
.border_loop:
    mov ax, bx
    push bx
    mov bx, 73
    call xy_to_di
    pop bx
    mov word [es:di], 0x0FB3
    
    mov ax, bx
    push bx
    mov bx, 76
    call xy_to_di
    pop bx
    mov word [es:di], 0x0FB3
    
    inc bx
    loop .border_loop
    
    ; Bottom border
    mov ax, 24
    mov bx, 73
    call xy_to_di
    mov word [es:di], 0x0FC0
    mov word [es:di+2], 0x0FC4
    mov word [es:di+4], 0x0FC4
    mov word [es:di+6], 0x0FD9
    
    pop dx
    pop cx
    pop bx
    pop ax
    pop di
    pop es
    ret

; --------------------------------
; Display Score
; --------------------------------
display_info:
    push es
    push di
    push ax
    push bx
    
    mov ax, 0xb800
    mov es, ax
    
    xor ax, ax
    mov bx, 2
    call xy_to_di
    mov word [es:di], 0x0F53
    mov word [es:di+2], 0x0F63
    mov word [es:di+4], 0x0F6F
    mov word [es:di+6], 0x0F72
    mov word [es:di+8], 0x0F65
    mov word [es:di+10], 0x0F3A
    
    mov ax, [score]
    mov bx, 9
    call xy_to_di
    add di, 2
    call print_number
    
    pop bx
    pop ax
    pop di
    pop es
    ret

; --------------------------------
; Print number
; --------------------------------
print_number:
    push ax
    push bx
    push cx
    push dx
    
    mov bx, 10
    xor cx, cx
    
.divide:
    xor dx, dx
    div bx
    push dx
    inc cx
    test ax, ax
    jnz .divide
    
.print:
    pop dx
    add dl, '0'
    mov dh, 0x0F
    mov [es:di], dx
    add di, 2
    loop .print
    
    pop dx
    pop cx
    pop bx
    pop ax
    ret

; --------------------------------
; Random number generator
; --------------------------------
random:
    push dx
    push cx
    
    mov ax, [random_seed]
    mov cx, 25173
    mul cx
    add ax, 13849
    mov [random_seed], ax
    
    pop cx
    pop dx
    ret

; --------------------------------
; Get random lane for obstacles (23, 34, or 45)
; --------------------------------
get_random_lane:
    call random
    xor dx, dx
    mov cx, 3
    div cx
    
    cmp dx, 0
    je .left
    cmp dx, 1
    je .center
    mov ax, 45
    ret
.center:
    mov ax, 34
    ret
.left:
    mov ax, 23
    ret

; --------------------------------
; Get random lane for coin (24, 35, or 46)
; --------------------------------
get_random_lane_coin:
    call random
    xor dx, dx
    mov cx, 3
    div cx
    
    cmp dx, 0
    je .left
    cmp dx, 1
    je .center
    mov ax, 46
    ret
.center:
    mov ax, 35
    ret
.left:
    mov ax, 24
    ret

; --------------------------------
; Get random lane for fuel (25, 36, or 47) - Simple version
; --------------------------------
get_random_lane_fuel:
    call random
    xor dx, dx
    mov cx, 3
    div cx
    
    cmp dx, 0
    je .left
    cmp dx, 1
    je .center
    mov ax, 47
    ret
.center:
    mov ax, 36
    ret
.left:
    mov ax, 25
    ret

; --------------------------------
; Delay
; --------------------------------
delay:
    push cx
    mov cx, 3
.outer:
    push cx
    mov cx, 0xFFFF
.inner:
    nop
    loop .inner
    pop cx
    loop .outer
    pop cx
    ret

; --------------------------------
; Clear Screen
; --------------------------------
clrscr:
    push es
    push ax
    push di
    push cx
    mov ax, 0xb800
    mov es, ax
    xor di, di
    mov cx, 2000
    mov ax, 0x0720
    rep stosw
    pop cx
    pop di
    pop ax
    pop es
    ret

; --------------------------------
; Draw one row of background
; --------------------------------
draw_row_at:
    push ax
    push bx
    push cx
    push di
    push es
    push dx
    
    mov dx, ax
    push ax
    mov ax, 0xb800
    mov es, ax
    pop ax
    
    mov bx, 0
    call xy_to_di
    
    ; Left grass (18 chars)
    mov cx, 18
.l_grass:
    mov word [es:di], 0x2220
    add di, 2
    loop .l_grass
    
    ; Left border
    mov word [es:di], 0x0FDB
    add di, 2
    
    ; Left lane (10 chars)
    mov cx, 10
.left_lane:
    mov word [es:di], 0x7020
    add di, 2
    loop .left_lane
    
    ; Lane divider 1
    mov ax, dx
    add ax, [lane_scroll]
    and ax, 3
    cmp ax, 1
    jle .div1_dash
    mov word [es:di], 0x7020
    jmp .div1_done
.div1_dash:
    mov word [es:di], 0x7FB3
.div1_done:
    add di, 2
    
    ; Center lane (10 chars)
    mov cx, 10
.center_lane:
    mov word [es:di], 0x7020
    add di, 2
    loop .center_lane
    
    ; Lane divider 2
    mov ax, dx
    add ax, [lane_scroll]
    and ax, 3
    cmp ax, 1
    jle .div2_dash
    mov word [es:di], 0x7020
    jmp .div2_done
.div2_dash:
    mov word [es:di], 0x7FB3
.div2_done:
    add di, 2
    
    ; Right lane (10 chars)
    mov cx, 10
.right_lane:
    mov word [es:di], 0x7020
    add di, 2
    loop .right_lane
    
    ; Right border
    mov word [es:di], 0x0FDB
    add di, 2
    
    ; Right grass (20 chars)
    mov cx, 20
.r_grass:
    mov word [es:di], 0x2220
    add di, 2
    loop .r_grass
    
    pop dx
    pop es
    pop di
    pop cx
    pop bx
    pop ax
    ret

; --------------------------------
; Draw Background
; --------------------------------
draw_background:
    push ax
    push cx
    
    mov cx, 25
    mov ax, 0
.loop:
    push ax
    call draw_row_at
    pop ax
    inc ax
    loop .loop
    
    pop cx
    pop ax
    ret

; --------------------------------
; Draw Confirmation Dialog
; --------------------------------
draw_confirmation:
    push es
    push di
    push ax
    push bx
    push cx
    
    mov ax, 0xb800
    mov es, ax
    
    ; Draw box background
    mov cx, 10
    mov bx, 8
.box_loop:
    mov ax, bx
    push bx
    mov bx, 20
    call xy_to_di
    pop bx
    
    push cx
    mov cx, 40
.fill_row:
    mov word [es:di], 0x1F20
    add di, 2
    loop .fill_row
    pop cx
    
    inc bx
    loop .box_loop
    
    ; Draw border - top
    mov ax, 8
    mov bx, 20
    call xy_to_di
    mov word [es:di], 0x1FDA
    add di, 2
    mov cx, 38
.top_border:
    mov word [es:di], 0x1FC4
    add di, 2
    loop .top_border
    mov word [es:di], 0x1FBF
    
    ; Side borders
    mov cx, 8
    mov bx, 9
.side_loop:
    mov ax, bx
    push bx
    mov bx, 20
    call xy_to_di
    pop bx
    mov word [es:di], 0x1FB3
    
    mov ax, bx
    push bx
    mov bx, 59
    call xy_to_di
    pop bx
    mov word [es:di], 0x1FB3
    
    inc bx
    loop .side_loop
    
    ; Bottom border
    mov ax, 17
    mov bx, 20
    call xy_to_di
    mov word [es:di], 0x1FC0
    add di, 2
    mov cx, 38
.bottom_border:
    mov word [es:di], 0x1FC4
    add di, 2
    loop .bottom_border
    mov word [es:di], 0x1FD9
    
    ; Display message
    mov ax, 11
    mov bx, 30
    call xy_to_di
    
    mov si, quit_msg
.print_quit:
    lodsb
    cmp al, 0
    je .done_quit
    mov ah, 0x1F
    mov [es:di], ax
    add di, 2
    jmp .print_quit
    
.done_quit:
    mov ax, 13
    mov bx, 28
    call xy_to_di
    
    mov si, yn_msg
.print_yn:
    lodsb
    cmp al, 0
    je .done_yn
    mov ah, 0x1E
    mov [es:di], ax
    add di, 2
    jmp .print_yn
    
.done_yn:
    pop cx
    pop bx
    pop ax
    pop di
    pop es
    ret

quit_msg: db 'Do you want to quit?', 0
yn_msg: db 'Y (Yes) / N (No)', 0
start_msg: db 'Press any key to START', 0

; --------------------------------
; Keyboard ISR
; --------------------------------
kbisr:
    push ax
    push bx
    push ds
    
    push cs
    pop ds
    
    in al, 0x60
    
    ; Ignore key releases
    test al, 0x80
    jnz .eoi
    
    ; Check game state
    cmp byte [game_started], 0
    jne .check_confirm
    
    ; Start game on any key
    mov byte [game_started], 1
    jmp .eoi
    
.check_confirm:
    cmp byte [show_confirmation], 1
    je .handle_confirm
    
    ; Normal controls
    cmp al, 0x01        ; ESC
    je .show_confirm
    cmp al, 0x4B        ; Left
    je .move_left
    cmp al, 0x4D        ; Right
    je .move_right
    jmp .eoi
    
.show_confirm:
    mov byte [show_confirmation], 1
    jmp .eoi
    
.handle_confirm:
    cmp al, 0x15        ; Y
    je .quit
    cmp al, 0x31        ; N
    je .resume
    cmp al, 0x01        ; ESC
    je .resume
    jmp .eoi
    
.quit:
    mov byte [game_paused], 1
    mov byte [show_confirmation], 0
    jmp .eoi
    
.resume:
    mov byte [show_confirmation], 0
    jmp .eoi
    
.move_left:
    mov ax, [player_col]
    cmp ax, 23
    je .eoi
    cmp ax, 34
    je .to_left
    mov word [player_col], 34
    jmp .eoi
.to_left:
    mov word [player_col], 23
    jmp .eoi
    
.move_right:
    mov ax, [player_col]
    cmp ax, 45
    je .eoi
    cmp ax, 34
    je .to_right
    mov word [player_col], 34
    jmp .eoi
.to_right:
    mov word [player_col], 45
    
.eoi:
    mov al, 0x20
    out 0x20, al
    
    pop ds
    pop bx
    pop ax
    iret

; --------------------------------
; Main Game Loop
; --------------------------------
game_loop:
    cmp byte [game_started], 0
    je .wait_start
    
    cmp byte [game_paused], 1
    je .exit
    
    cmp byte [show_confirmation], 1
    je .show_dialog
    
    ; Update game
    inc word [lane_scroll]
    inc word [frame_count]
    
    ; Update obstacles
    mov ax, [obstacle1_row]
    mov bx, [obstacle1_col]
    call clear_car
    inc word [obstacle1_row]
    cmp word [obstacle1_row], 22
    jl .draw_o1
    mov word [obstacle1_row], 0
    call get_random_lane
    mov [obstacle1_col], ax
.draw_o1:
    
    mov ax, [obstacle2_row]
    mov bx, [obstacle2_col]
    call clear_car
    inc word [obstacle2_row]
    cmp word [obstacle2_row], 22
    jl .draw_o2
    mov word [obstacle2_row], 0
    call get_random_lane
    mov [obstacle2_col], ax
.draw_o2:
    
    mov ax, [obstacle3_row]
    mov bx, [obstacle3_col]
    call clear_car
    inc word [obstacle3_row]
    cmp word [obstacle3_row], 22
    jl .draw_o3
    mov word [obstacle3_row], 0
    call get_random_lane
    mov [obstacle3_col], ax
.draw_o3:
    
    ; Update coin
    mov ax, [coin_row]
    mov bx, [coin_col]
    call clear_coin
    inc word [coin_row]
    cmp word [coin_row], 24
    jl .draw_c
    mov word [coin_row], 0
    call get_random_lane_coin
    mov [coin_col], ax
.draw_c:
    
    ; Update fuel
    mov ax, [fuel_row]
    mov bx, [fuel_col]
    call clear_fuel
    inc word [fuel_row]
    cmp word [fuel_row], 24
    jl .draw_f
    mov word [fuel_row], 10
    call get_random_lane_fuel
    mov [fuel_col], ax
.draw_f:
    
    ; Draw everything
    call draw_background
    call draw_player
    
    mov ax, [obstacle1_row]
    mov bx, [obstacle1_col]
    call draw_obstacle
    
    mov ax, [obstacle2_row]
    mov bx, [obstacle2_col]
    call draw_obstacle
    
    mov ax, [obstacle3_row]
    mov bx, [obstacle3_col]
    call draw_obstacle
    
    mov ax, [coin_row]
    mov bx, [coin_col]
    call draw_coin
    
    mov ax, [fuel_row]
    mov bx, [fuel_col]
    call draw_fuel
    
    call draw_fuel_bar
    call display_info
    
    ; Update score/fuel every 16 frames
    mov ax, [frame_count]
    and ax, 0x0F
    jnz .no_update
    inc word [score]
    cmp word [fuel_level], 0
    je .no_update
    dec word [fuel_level]
.no_update:
    
    call delay
    jmp game_loop
    
.wait_start:
    call draw_background
    
    push es
    mov ax, 0xb800
    mov es, ax
    mov ax, 12
    mov bx, 28
    call xy_to_di
    mov si, start_msg
.print_s:
    lodsb
    cmp al, 0
    je .done_s
    mov ah, 0x0E
    mov [es:di], ax
    add di, 2
    jmp .print_s
.done_s:
    pop es
    
    call delay
    jmp game_loop
    
.show_dialog:
    call draw_confirmation
    call delay
    jmp game_loop
    
.exit:
    ret

; --------------------------------
; Hook Keyboard
; --------------------------------
hook_keyboard:
    push es
    push ax
    
    xor ax, ax
    mov es, ax
    
    mov ax, [es:9*4]
    mov [old_kbd_isr], ax
    mov ax, [es:9*4+2]
    mov [old_kbd_isr+2], ax
    
    cli
    mov word [es:9*4], kbisr
    mov word [es:9*4+2], cs
    sti
    
    pop ax
    pop es
    ret

; --------------------------------
; Unhook Keyboard
; --------------------------------
unhook_keyboard:
    push es
    push ax
    
    xor ax, ax
    mov es, ax
    
    cli
    mov ax, [old_kbd_isr]
    mov [es:9*4], ax
    mov ax, [old_kbd_isr+2]
    mov [es:9*4+2], ax
    sti
    
    pop ax
    pop es
    ret

; --------------------------------
; Start
; --------------------------------
Start:
    call hook_keyboard
    call clrscr
    call draw_background
    call game_loop
    call unhook_keyboard
    call clrscr
    
    mov ax, 4C00h
    int 21h