[org 0x100]
jmp Start


; CONFIGURATION VARIABLES
screen_seg: dw 0xb800
screen_width: dw 80
screen_height: dw 25

lane_left_col: dw 22
lane_center_col: dw 33
lane_right_col: dw 44
lane_width: dw 10

car_width: dw 4
car_height: dw 3

coin_width: dw 3
coin_height: dw 3
fuel_width: dw 2
fuel_height: dw 1

min_gap_between_items: dw 5
obstacle_spawn_rate: dw 12
coin_spawn_rate: dw 25
fuel_spawn_rate: dw 120    ;larger for less fuel icon

color_road: dw 0x0020
color_grass: dw 0x0220
color_divider: dw 0xF0B3
color_border: dw 0x07DB


; GAME STATE VARIABLES
player_row: dw 20
player_col: dw 33
player_lane: db 1

obstacle_row: dw -3
obstacle_col: dw 22
obstacle_active: db 1
obstacle_lane: db 0

coin_row: dw -3
coin_col: dw 34
coin_active: db 0

fuel_row: dw -1
fuel_col: dw 45
fuel_active: db 0

last_spawn_row: dw 0
rows_since_obstacle: dw 100
rows_since_coin: dw 20
rows_since_fuel: dw 0

score: dw 0
coins_collected: dw 0
fuel_level: dw 100
frame_count: dw 0
lane_scroll: dw 0
random_seed: dw 12345

music_enabled: db 1
music_index: dw 0
music_tick_counter: dw 0
music_ticks_per_note: dw 10      ; Adjust for tempo
; Frames per note (lower = faster)
music_length: dw 32              ; Total notes in melody



ambient_sound_enabled: db 1
ambient_tick_counter: dw 0
ambient_ticks_per_note: dw 30
ambient_note_index: dw 0
ambient_length: dw 16
show_waiting_screen: db 0

; Timer ISR
old_timer_isr: dd 0

lane_change_cooldown: dw 0
lane_change_delay: dw 8        ; Adjust this value to change delay duration

; Game state flags
game_started: db 0
game_paused: db 0
game_over: db 0
show_confirmation: db 0
show_input_screen: db 0
show_instructions: db 0
show_title_screen: db 1
show_gameover_popup: db 0
show_stats_screen: db 0
end_reason: db 0
gameover_drawn: db 0
confirm_drawn: db 0

; Input state
input_field: db 0
name_pos: db 0
roll_pos: db 0

; Player info buffers
player_name: times 21 db 0
player_roll: times 16 db 0

; Key state
key_left_pressed: db 0
key_right_pressed: db 0
key_up_pressed: db 0     
key_down_pressed: db 0    

; Title screen animation
star1_pos: dw 0x0000
star2_pos: dw 0x0000
star3_pos: dw 0x0000
star4_pos: dw 0x0000
star5_pos: dw 0x0000
star6_pos: dw 0x0000
star7_pos: dw 0x0000
star8_pos: dw 0x0000
star9_pos: dw 0x0000
star10_pos: dw 0x0000
star11_pos: dw 0x0000
star12_pos: dw 0x0000
star13_pos: dw 0x0000
star14_pos: dw 0x0000
star15_pos: dw 0x0000
star_side: db 0x00
lane_offset: db 0x00
title_frame: dw 0
input_drawn: db 0
instr_drawn: db 0

; Keyboard
old_kbd_isr: dd 0

; STRINGS
quit_msg: db 'Do you want to quit?', 0
yn_msg: db 'Y (Yes) / N (No)', 0
start_msg: db 'Press any key to START', 0
gameover_msg: db 'GAME OVER', 0
reason_quit: db 'You quit the game', 0
reason_fuel: db 'You ran out of fuel!', 0
reason_crash: db 'You crashed!', 0
presskey_msg: db 'Press any key to continue...', 0
name_label: db 'Name: ', 0
roll_label: db 'Roll No: ', 0
coins_label: db 'Coins: ', 0
score_label: db 'Score: ', 0
stats_instr1: db 'SPACE - Main Menu', 0
stats_instr2: db 'ESC - Exit Game', 0
input_title: db 'ENTER YOUR DETAILS', 0
input_name: db 'Name: ', 0
input_roll: db 'Roll No: ', 0
input_instr: db 'TAB=switch, ENTER=start', 0
instr_title: db 'INSTRUCTIONS', 0
instr_1: db 'LEFT/RIGHT - Change lanes', 0
instr_2: db 'Q - Quit to stats', 0
instr_3: db 'ESC - Exit game', 0
instr_4: db 'Collect coins, avoid cars!', 0
instr_press: db 'Press any key to continue...', 0
title_press: db 'Press any key to start...', 0
developer_1: db 'Maida Adnan    24L-0650', 0
developer_2: db 'Hira Waseem    24L-0521', 0

; SCANCODE TO ASCII TABLE
scancode_to_ascii:
    db 0, 0, '1', '2', '3', '4', '5', '6', '7', '8', '9', '0', '-', '=', 0, 0
    db 'q', 'w', 'e', 'r', 't', 'y', 'u', 'i', 'o', 'p', '[', ']', 0, 0
    db 'a', 's', 'd', 'f', 'g', 'h', 'j', 'k', 'l', ';', "'", '`', 0, '\'
    db 'z', 'x', 'c', 'v', 'b', 'n', 'm', ',', '.', '/', 0, '*', 0, ' '
    times 70 db 0

; Music notes (frequencies in Hz)
NOTE_C4  equ 262
NOTE_D4  equ 294
NOTE_E4  equ 330
NOTE_F4  equ 349
NOTE_G4  equ 392
NOTE_A4  equ 440
NOTE_B4  equ 494
NOTE_C5  equ 523
NOTE_D5  equ 587
NOTE_E5  equ 659
NOTE_G5  equ 784
NOTE_A5  equ 880
NOTE_REST equ 0

music_data:
    dw NOTE_E5, NOTE_E5, NOTE_REST, NOTE_E5
    dw NOTE_REST, NOTE_C5, NOTE_E5, NOTE_REST
    dw NOTE_G5, NOTE_REST, NOTE_REST, NOTE_REST
    dw NOTE_G4, NOTE_REST, NOTE_REST, NOTE_REST
    dw NOTE_C5, NOTE_REST, NOTE_REST, NOTE_G4
    dw NOTE_REST, NOTE_REST, NOTE_E4, NOTE_REST
    dw NOTE_REST, NOTE_A4, NOTE_REST, NOTE_B4
    dw NOTE_REST, NOTE_A4, NOTE_A4, NOTE_REST

NOTE_C3 equ 131
NOTE_D3 equ 147
NOTE_E3 equ 165

ambient_music_data:
    dw NOTE_C3, NOTE_E3, NOTE_C3, NOTE_D3
    dw 0, NOTE_C3, NOTE_E3, 0
    dw NOTE_D3, NOTE_C3, 0, NOTE_E3
    dw NOTE_C3, 0, NOTE_D3, 0

xy_to_di:
    push dx
    push bx
    mov dx, ax
    mov ax, [screen_width]
    mul dx
    pop bx
    add ax, bx
    shl ax, 1
    mov di, ax
    pop dx
    ret

get_lane_col:
    cmp al, 0
    je .left
    cmp al, 1
    je .center
    mov ax, [lane_right_col]
    ret
.center:
    mov ax, [lane_center_col]
    ret
.left:
    mov ax, [lane_left_col]
    ret

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

get_random_lane:
    call random
    xor dx, dx
    mov cx, 3
    div cx
    mov al, dl
    ret

draw_car_row:
    push es
    push di
    push ax
    push bx
    push dx
    mov dx, [screen_seg]
    mov es, dx
    pop dx
    call xy_to_di
    cmp dl, 0
    je .row0
    cmp dl, 1
    je .row1
    jmp .row2
.row0:
    mov word [es:di], 0xFEFE
    cmp cl, 0
    je .row0_red
    mov word [es:di+2], 0x19DF
    mov word [es:di+4], 0x19DF
    jmp .row0_done
.row0_red:
    mov word [es:di+2], 0x4CDF
    mov word [es:di+4], 0x4CDF
.row0_done:
    mov word [es:di+6], 0xFEFE
    jmp .done
.row1:
    cmp cl, 0
    je .row1_red
    mov word [es:di], 0x19DB
    mov word [es:di+2], 0x09DB
    mov word [es:di+4], 0x09DB
    mov word [es:di+6], 0x19DB
    jmp .done
.row1_red:
    mov word [es:di], 0x4CDB
    mov word [es:di+2], 0x09DB
    mov word [es:di+4], 0x09DB
    mov word [es:di+6], 0x4CDB
    jmp .done
.row2:
    mov word [es:di], 0x08FE
    cmp cl, 0
    je .row2_red
    mov word [es:di+2], 0x19DC
    mov word [es:di+4], 0x19DC
    jmp .row2_done
.row2_red:
    mov word [es:di+2], 0x4CDC
    mov word [es:di+4], 0x4CDC
.row2_done:
    mov word [es:di+6], 0x08FE
.done:
    pop bx
    pop ax
    pop di
    pop es
    ret

draw_player:
    push ax
    push bx
    push cx
    push dx
    mov ax, [player_row]
    mov bx, [player_col]
    mov cl, 0
    mov dl, 0
    call draw_car_row
    inc ax
    mov dl, 1
    call draw_car_row
    inc ax
    mov dl, 2
    call draw_car_row
    pop dx
    pop cx
    pop bx
    pop ax
    ret

draw_obstacle:
    push ax
    push bx
    push cx
    push dx
    cmp byte [obstacle_active], 0
    je .done
    mov ax, [obstacle_row]
    mov bx, [obstacle_col]
    mov cl, 1
    cmp ax, 0
    jl .check_row1
    mov dl, 0
    call draw_car_row
.check_row1:
    mov ax, [obstacle_row]
    inc ax
    cmp ax, 0
    jl .check_row2
    cmp ax, [screen_height]
    jge .done
    mov dl, 1
    call draw_car_row
.check_row2:
    mov ax, [obstacle_row]
    add ax, 2
    cmp ax, 0
    jl .done
    cmp ax, [screen_height]
    jge .done
    mov dl, 2
    call draw_car_row
.done:
    pop dx
    pop cx
    pop bx
    pop ax
    ret

clear_car_at:
    push es
    push di
    push ax
    push bx
    push cx
    push dx
    mov dx, [screen_seg]
    mov es, dx
    mov cx, [car_height]
    mov dx, ax
.clear_row:
    mov ax, dx
    cmp ax, 0
    jl .next_row
    cmp ax, [screen_height]
    jge .done
    call xy_to_di
    push dx
    mov dx, [color_road]
    mov [es:di], dx
    mov [es:di+2], dx
    mov [es:di+4], dx
    mov [es:di+6], dx
    pop dx
.next_row:
    inc dx
    loop .clear_row
.done:
    pop dx
    pop cx
    pop bx
    pop ax
    pop di
    pop es
    ret

draw_coin:
    push es
    push di
    push ax
    push bx
    push cx
    push dx
    cmp byte [coin_active], 0
    je .done
    mov dx, [screen_seg]
    mov es, dx
    mov dx, [coin_row]
    mov cx, [coin_col]
    mov bx, cx
    mov ax, dx
    cmp ax, 0
    jl .row1
    cmp ax, [screen_height]
    jge .done
    call xy_to_di
    mov word [es:di], 0x0020
    mov word [es:di+2], 0x0E2A
    mov word [es:di+4], 0x0020
.row1:
    mov ax, dx
    inc ax
    cmp ax, 0
    jl .row2
    cmp ax, [screen_height]
    jge .done
    mov bx, cx
    call xy_to_di
    mov word [es:di], 0x0E2A
    mov word [es:di+2], 0x0E2A
    mov word [es:di+4], 0x0E2A
.row2:
    mov ax, dx
    add ax, 2
    cmp ax, 0
    jl .done
    cmp ax, [screen_height]
    jge .done
    mov bx, cx
    call xy_to_di
    mov word [es:di], 0x0020
    mov word [es:di+2], 0x0E2A
    mov word [es:di+4], 0x0020
.done:
    pop dx
    pop cx
    pop bx
    pop ax
    pop di
    pop es
    ret

clear_coin:
    push es
    push di
    push ax
    push bx
    push cx
    push dx
    mov dx, [screen_seg]
    mov es, dx
    mov cx, [coin_height]
    mov dx, [coin_row]
    mov bx, [coin_col]
.clear_row:
    mov ax, dx
    cmp ax, 0
    jl .next
    cmp ax, [screen_height]
    jge .done
    call xy_to_di
    push dx
    mov dx, [color_road]
    mov [es:di], dx
    mov [es:di+2], dx
    mov [es:di+4], dx
    pop dx
.next:
    inc dx
    loop .clear_row
.done:
    pop dx
    pop cx
    pop bx
    pop ax
    pop di
    pop es
    ret

draw_fuel:
    push es
    push di
    push ax
    push bx
    cmp byte [fuel_active], 0
    je .done
    mov ax, [fuel_row]
    cmp ax, 0
    jl .done
    cmp ax, [screen_height]
    jge .done
    mov bx, [screen_seg]
    mov es, bx
    mov bx, [fuel_col]
    call xy_to_di
    mov word [es:di], 0xAF46
    mov word [es:di+2], 0xAADB
.done:
    pop bx
    pop ax
    pop di
    pop es
    ret

clear_fuel:
    push es
    push di
    push ax
    push bx
    mov ax, [fuel_row]
    cmp ax, 0
    jl .done
    cmp ax, [screen_height]
    jge .done
    mov bx, [screen_seg]
    mov es, bx
    mov bx, [fuel_col]
    call xy_to_di
    mov dx, [color_road]
    mov [es:di], dx
    mov [es:di+2], dx
.done:
    pop bx
    pop ax
    pop di
    pop es
    ret

spawn_obstacle:
    push ax
    push bx
    cmp byte [obstacle_active], 1
    je .done
    mov ax, [rows_since_obstacle]
    cmp ax, [obstacle_spawn_rate]
    jl .done
    mov byte [obstacle_active], 1
    mov word [obstacle_row], -3
    mov word [rows_since_obstacle], 0
    call get_random_lane
    mov [obstacle_lane], al
    call get_lane_col
    mov [obstacle_col], ax
.done:
    pop bx
    pop ax
    ret

spawn_coin:
    push ax
    push bx
    cmp byte [coin_active], 1
    je .done
    mov ax, [rows_since_coin]
    cmp ax, [coin_spawn_rate]
    jl .done
    cmp byte [obstacle_active], 1
    jne .can_spawn
    mov ax, [obstacle_row]
    cmp ax, [min_gap_between_items]
    jl .done
.can_spawn:
    mov byte [coin_active], 1
    mov word [coin_row], -3
    mov word [rows_since_coin], 0
    call get_random_lane
    cmp al, 0
    je .left_lane
    cmp al, 1
    je .center_lane
    mov ax, [lane_right_col]
    add ax, 1
    jmp .set_col
.center_lane:
    mov ax, [lane_center_col]
    add ax, 1
    jmp .set_col
.left_lane:
    mov ax, [lane_left_col]
    add ax, 1
.set_col:
    mov [coin_col], ax
.done:
    pop bx
    pop ax
    ret

spawn_fuel:
    push ax
    push bx
    cmp byte [fuel_active], 1
    je .done
    mov ax, [rows_since_fuel]
    cmp ax, [fuel_spawn_rate]
    jl .done
    cmp byte [obstacle_active], 1
    jne .check_coin
    mov ax, [obstacle_row]
    cmp ax, [min_gap_between_items]
    jl .done
.check_coin:
    cmp byte [coin_active], 1
    jne .can_spawn
    mov ax, [coin_row]
    cmp ax, [min_gap_between_items]
    jl .done
.can_spawn:
    mov byte [fuel_active], 1
    mov word [fuel_row], -1
    mov word [rows_since_fuel], 0
    call get_random_lane
    cmp al, 0
    je .left_lane
    cmp al, 1
    je .center_lane
    mov ax, [lane_right_col]
    add ax, 2
    jmp .set_col
.center_lane:
    mov ax, [lane_center_col]
    add ax, 2
    jmp .set_col
.left_lane:
    mov ax, [lane_left_col]
    add ax, 2
.set_col:
    mov [fuel_col], ax
.done:
    pop bx
    pop ax
    ret

update_obstacle:
    push ax
    push bx
    inc word [rows_since_obstacle]
    cmp byte [obstacle_active], 0
    je .done
    mov ax, [obstacle_row]
    mov bx, [obstacle_col]
    call clear_car_at
    inc word [obstacle_row]
    mov ax, [obstacle_row]
    cmp ax, [screen_height]
    jl .done
    mov byte [obstacle_active], 0
.done:
    pop bx
    pop ax
    ret

update_coin:
    push ax
    inc word [rows_since_coin]
    cmp byte [coin_active], 0
    je .done
    call clear_coin
    inc word [coin_row]
    mov ax, [coin_row]
    cmp ax, [screen_height]
    jl .done
    mov byte [coin_active], 0
.done:
    pop ax
    ret

update_fuel:
    push ax
    inc word [rows_since_fuel]
    cmp byte [fuel_active], 0
    je .done
    call clear_fuel
    inc word [fuel_row]
    mov ax, [fuel_row]
    cmp ax, [screen_height]
    jl .done
    mov byte [fuel_active], 0
.done:
    pop ax
    ret

draw_row_background:
    push ax
    push bx
    push cx
    push di
    push es
    push dx
    mov dx, ax
    mov bx, [screen_seg]
    mov es, bx
    mov bx, 0
    call xy_to_di
    mov cx, 18
.l_grass:
    push dx
    mov dx, [color_grass]
    mov [es:di], dx
    pop dx
    add di, 2
    loop .l_grass
    push dx
    mov dx, [color_border]
    mov [es:di], dx
    pop dx
    add di, 2
    mov cx, [lane_width]
.left_lane:
    push dx
    mov dx, [color_road]
    mov [es:di], dx
    pop dx
    add di, 2
    loop .left_lane
    mov ax, dx
    add ax, [lane_scroll]
    and ax, 3
    cmp ax, 1
    jle .div1_on
    push dx
    mov dx, [color_road]
    mov [es:di], dx
    pop dx
    jmp .div1_done
.div1_on:
    push dx
    mov dx, [color_divider]
    mov [es:di], dx
    pop dx
.div1_done:
    add di, 2
    mov cx, [lane_width]
.center_lane:
    push dx
    mov dx, [color_road]
    mov [es:di], dx
    pop dx
    add di, 2
    loop .center_lane
    mov ax, dx
    add ax, [lane_scroll]
    and ax, 3
    cmp ax, 1
    jle .div2_on
    push dx
    mov dx, [color_road]
    mov [es:di], dx
    pop dx
    jmp .div2_done
.div2_on:
    push dx
    mov dx, [color_divider]
    mov [es:di], dx
    pop dx
.div2_done:
    add di, 2
    mov cx, [lane_width]
.right_lane:
    push dx
    mov dx, [color_road]
    mov [es:di], dx
    pop dx
    add di, 2
    loop .right_lane
    push dx
    mov dx, [color_border]
    mov [es:di], dx
    pop dx
    add di, 2
    mov cx, 20
.r_grass:
    push dx
    mov dx, [color_grass]
    mov [es:di], dx
    pop dx
    add di, 2
    loop .r_grass
    pop dx
    pop es
    pop di
    pop cx
    pop bx
    pop ax
    ret

draw_background:
    push ax
    push cx
    mov cx, [screen_height]
    xor ax, ax
.loop:
    push ax
    call draw_row_background
    pop ax
    inc ax
    loop .loop
    pop cx
    pop ax
    ret

draw_fuel_bar:
    push es
    push di
    push ax
    push bx
    push cx
    push dx
    mov ax, [screen_seg]
    mov es, ax
    mov ax, 2
    mov bx, 72
    call xy_to_di
    mov word [es:di], 0xAF46
    mov word [es:di+2], 0xAF55
    mov word [es:di+4], 0xAF45
    mov word [es:di+6], 0xAF4C
    mov ax, [fuel_level]
    xor dx, dx
    mov cx, 5
    div cx
    mov dx, ax
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
    jge .empty
    cmp dx, 14
    jge .green
    cmp dx, 7
    jge .yellow
    mov word [es:di], 0xCCDB
    mov word [es:di+2], 0xCCDB
    jmp .next
.green:
    mov word [es:di], 0xAADB
    mov word [es:di+2], 0xAADB
    jmp .next
.yellow:
    mov word [es:di], 0xEEDB
    mov word [es:di+2], 0xEEDB
    jmp .next
.empty:
    mov word [es:di], 0x0820
    mov word [es:di+2], 0x0820
.next:
    pop dx
    pop cx
    inc bx
    loop .bar_loop
    mov ax, 3
    mov bx, 73
    call xy_to_di
    mov word [es:di], 0x3FDA
    mov word [es:di+2], 0x3FC4
    mov word [es:di+4], 0x3FC4
    mov word [es:di+6], 0x3FBF
    mov cx, 20
    mov bx, 4
.border_loop:
    mov ax, bx
    push bx
    mov bx, 73
    call xy_to_di
    pop bx
    mov word [es:di], 0x3FB3
    mov ax, bx
    push bx
    mov bx, 76
    call xy_to_di
    pop bx
    mov word [es:di], 0x3FB3
    inc bx
    loop .border_loop
    mov ax, 24
    mov bx, 73
    call xy_to_di
    mov word [es:di], 0x3FC0
    mov word [es:di+2], 0x3FC4
    mov word [es:di+4], 0x3FC4
    mov word [es:di+6], 0x3FD9
    pop dx
    pop cx
    pop bx
    pop ax
    pop di
    pop es
    ret

display_score:
    push es
    push di
    push ax
    push bx
    mov ax, [screen_seg]
    mov es, ax
   
    ; Display "Score:"
    xor ax, ax
    mov bx, 2
    call xy_to_di
    mov word [es:di], 0x0F53
    mov word [es:di+2], 0x0F63
    mov word [es:di+4], 0x0F6F
    mov word [es:di+6], 0x0F72
    mov word [es:di+8], 0x0F65
    mov word [es:di+10], 0x0F3A
   
; Display score value
    xor ax, ax             
    mov bx, 9              
    call xy_to_di
    add di, 2
    mov ax, [score]       
    call print_number
   
    ; Display "Coins:" on second line
    mov ax, 1
    mov bx, 2
    call xy_to_di
    mov word [es:di], 0x0E43      ; C
    mov word [es:di+2], 0x0E6F    ; o
    mov word [es:di+4], 0x0E69    ; i
    mov word [es:di+6], 0x0E6E    ; n
    mov word [es:di+8], 0x0E73    ; s
    mov word [es:di+10], 0x0E3A   ; :
   
    ; Display coins collected
    mov ax, [coins_collected]
    mov bx, 9
    mov ax, 1
    call xy_to_di
    mov ax, [coins_collected]
    call print_number
   
    pop bx
    pop ax
    pop di
    pop es
    ret
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

move_player_left:
    push ax
    push bx
   
    ; Check if already at leftmost lane
    cmp byte [player_lane], 0
    je .done
   
    ; Check if obstacle would collide in target lane
    cmp byte [obstacle_active], 0
    je .safe_to_move
   
    ; Get obstacle row
    mov ax, [obstacle_row]
    cmp ax, 18
    jl .safe_to_move
    cmp ax, 23
    jg .safe_to_move
   
    ; Check if obstacle is in target lane (left)
    mov al, [player_lane]
    dec al
    mov bl, [obstacle_lane]
    cmp al, bl
    je .collision_detected
   
.safe_to_move:
    mov ax, [player_row]
    mov bx, [player_col]
    call clear_car_at
    dec byte [player_lane]
    mov al, [player_lane]
    call get_lane_col
    mov [player_col], ax
    jmp .done
   
.collision_detected:
    ; Move player to collision lane
    mov ax, [player_row]
    mov bx, [player_col]
    call clear_car_at
    dec byte [player_lane]
    mov al, [player_lane]
    call get_lane_col
    mov [player_col], ax
   
    call draw_spark  
    ; Set game over flags
    mov byte [end_reason], 2
    mov byte [show_gameover_popup], 1
    mov byte [gameover_drawn], 0    ; ← ADD THIS LINE
   
.done:
    pop bx
    pop ax
    ret

move_player_right:
    push ax
    push bx
   
    ; Check if already at rightmost lane
    cmp byte [player_lane], 2
    je .done
   
    ; Check if obstacle would collide in target lane
    cmp byte [obstacle_active], 0
    je .safe_to_move
   
    ; Get obstacle row
    mov ax, [obstacle_row]
    cmp ax, 18
    jl .safe_to_move
    cmp ax, 23
    jg .safe_to_move
   
    ; Check if obstacle is in target lane (right)
    mov al, [player_lane]
    inc al
    mov bl, [obstacle_lane]
    cmp al, bl
    je .collision_detected
   
.safe_to_move:
    mov ax, [player_row]
    mov bx, [player_col]
    call clear_car_at
    inc byte [player_lane]
    mov al, [player_lane]
    call get_lane_col
    mov [player_col], ax
    jmp .done
   
.collision_detected:
    ; Move player to collision lane
    mov ax, [player_row]
    mov bx, [player_col]
    call clear_car_at
    inc byte [player_lane]       ; inc not dec
    mov al, [player_lane]
    call get_lane_col
    mov [player_col], ax
   
    call draw_spark   
    ; Set game over flags
    mov byte [end_reason], 2
    mov byte [show_gameover_popup], 1
    mov byte [gameover_drawn], 0    ; ← ADD THIS LINE
   
.done:
    pop bx
    pop ax
    ret

move_player_up:
    push ax
    push bx
   
    ; Check if already at top (row 0)
    cmp word [player_row], 0
    jle .done
   
    ; Clear current position
    mov ax, [player_row]
    mov bx, [player_col]
    call clear_car_at
   
    ; Move up one row
    dec word [player_row]
   
.done:
    pop bx
    pop ax
    ret

move_player_down:
    push ax
    push bx
   
    ; Check if already at bottom
    ; Car is 3 rows tall, screen is 25 rows (0-24)
    ; Bottom position is row 22 (22 + 3 = 25)
    mov ax, [player_row]
    cmp ax, 22
    jge .done
   
    ; Clear current position
    mov ax, [player_row]
    mov bx, [player_col]
    call clear_car_at
   
    ; Move down one row
    inc word [player_row]
   
.done:
    pop bx
    pop ax
    ret
check_collision:
    push ax
    push bx
    push cx
   
    ; Check if obstacle is active
    cmp byte [obstacle_active], 0
    je .no_collision
   
    ; Check if obstacle is in player's vertical range (rows 18-22)
    mov ax, [obstacle_row]
    cmp ax, 18
    jl .no_collision
    cmp ax, 23
    jg .no_collision
   
    ; Check if obstacle is in same lane as player
    mov al, [obstacle_lane]
    mov bl, [player_lane]
    cmp al, bl
    jne .no_collision
   
    ; Collision detected!
	 call draw_spark  
    mov byte [end_reason], 2
 
    mov byte [show_gameover_popup], 1
    jmp .done
   
.no_collision:
.done:
    pop cx
    pop bx
    pop ax
    ret

check_coin_collection:
    push ax
    push bx
   
    ; Check if coin is active
    cmp byte [coin_active], 0
    je .no_collection
   
    ; Check if coin is in player's vertical range (rows 19-22)
    mov ax, [coin_row]
    cmp ax, 19
    jl .no_collection
    cmp ax, 23
    jg .no_collection
   
    ; Get player lane column
    mov al, [player_lane]
    call get_lane_col
    add ax, 1  ; Coin offset
    mov bx, ax
   
    ; Check if coin column matches
    mov ax, [coin_col]
    cmp ax, bx
    jne .no_collection
   
    ; Coin collected!
    inc word [coins_collected]
    add word [score], 10      ; Add 10 points per coin
    mov byte [coin_active], 0
    call clear_coin
   
.no_collection:
    pop bx
    pop ax
    ret

check_fuel_collection:
    push ax
    push bx
   
    ; Check if fuel is active
    cmp byte [fuel_active], 0
    je .no_collection
   
    ; Check if fuel is in player's vertical range (rows 19-22)
    mov ax, [fuel_row]
    cmp ax, 19
    jl .no_collection
    cmp ax, 23
    jg .no_collection
   
    ; Get player lane column
    mov al, [player_lane]
    call get_lane_col
    add ax, 2  ; Fuel offset
    mov bx, ax
   
    ; Check if fuel column matches
    mov ax, [fuel_col]
    cmp ax, bx
    jne .no_collection
   
    ; Fuel collected!
    add word [fuel_level], 20     ; Add 20 fuel
    cmp word [fuel_level], 100
    jle .fuel_ok
    mov word [fuel_level], 100    ; Cap at 100
.fuel_ok:
    mov byte [fuel_active], 0
    call clear_fuel
   
.no_collection:
    pop bx
    pop ax
    ret

draw_spark:
    push es
    push di
    push ax
    push bx
    push cx
   
    mov ax, [screen_seg]
    mov es, ax
   
    ; Draw sparks at collision point (around player car)
    mov ax, [player_row]
    mov bx, [player_col]
   
    ; Spark pattern around car
    dec ax
    dec bx
    call xy_to_di
    mov word [es:di], 0xEC2A
    mov word [es:di+2], 0xEE2A
    mov word [es:di+10], 0xEC2A
    mov word [es:di+12], 0xEE2A
   
    inc ax
    call xy_to_di
    mov word [es:di], 0xEE2A
    mov word [es:di+12], 0xEC2A
   
    add ax, 2
    call xy_to_di
    mov word [es:di], 0xEC2A
    mov word [es:di+2], 0xEE2A
    mov word [es:di+10], 0xEE2A
    mov word [es:di+12], 0xEC2A
   
    ; Delay to show spark
    mov cx, 10
.delay_outer:
    push cx
    mov cx, 0xFFFF
.delay_inner:
    nop
    loop .delay_inner
    pop cx
    loop .delay_outer
   
    pop cx
    pop bx
    pop ax
    pop di
    pop es
    ret


; Input: AX = frequency (0 = silence)
play_sound:
    push ax
    push bx
    push dx
   
    cmp ax, 0
    je .silence
   
    ; Calculate timer divisor: 1193180 / frequency
    mov bx, ax
    mov dx, 0x0012
    mov ax, 0x34DC
    div bx
    mov bx, ax
   
    ; Program PIT channel 2
    mov al, 0xB6
    out 0x43, al
    mov al, bl
    out 0x42, al
    mov al, bh
    out 0x42, al
   
    ; Turn on speaker
    in al, 0x61
    or al, 0x03
    out 0x61, al
    jmp .done
   
.silence:
    ; Turn off speaker
    in al, 0x61
    and al, 0xFC
    out 0x61, al
   
.done:
    pop dx
    pop bx
    pop ax
    ret

; Stop all sound
stop_sound:
    push ax
    in al, 0x61
    and al, 0xFC
    out 0x61, al
    pop ax
    ret


ambient_sound_process:
    push ax
    push bx
    push si
    push ds
   
    push cs
    pop ds
   
    cmp byte [ambient_sound_enabled], 0
    je .silence
   
    inc word [ambient_tick_counter]
    mov ax, [ambient_tick_counter]
    cmp ax, [ambient_ticks_per_note]
    jl .done
   
    mov word [ambient_tick_counter], 0
   
    mov si, ambient_music_data
    mov bx, [ambient_note_index]
    shl bx, 1
    add si, bx
    mov ax, [si]
   
    call play_sound
   
    inc word [ambient_note_index]
    mov ax, [ambient_note_index]
    cmp ax, [ambient_length]
    jl .done
   
    mov word [ambient_note_index], 0
    jmp .done
   
.silence:
    call stop_sound
   
.done:
    pop ds
    pop si
    pop bx
    pop ax
    ret

; MUSIC PROCESS - Runs in timer interrupt (separate from game)
; This is the "music process" that runs independently
music_process:
    push ax
    push bx
    push si
    push ds
   
    push cs
    pop ds
   
    ; Check if music enabled
    cmp byte [music_enabled], 0
    je .silence
   
    ; Check if game is running (only play during gameplay)
    cmp byte [game_started], 0
    je .silence
    cmp byte [show_title_screen], 1
    je .silence
    cmp byte [show_gameover_popup], 1
    je .silence
   
    ; Increment tick counter
    inc word [music_tick_counter]
    mov ax, [music_tick_counter]
    cmp ax, [music_ticks_per_note]
    jl .done
   
    ; Reset tick counter
    mov word [music_tick_counter], 0
   
    ; Get current note from melody
    mov si, music_data
    mov bx, [music_index]
    shl bx, 1                    ; Convert to byte offset
    add si, bx
    mov ax, [si]
   
    ; Play the note
    call play_sound
   
    ; Advance to next note
    inc word [music_index]
    mov ax, [music_index]
    cmp ax, [music_length]
    jl .done
   
    ; Loop back to start
    mov word [music_index], 0
    jmp .done
   
.silence:
    call stop_sound
   
.done:
    pop ds
    pop si
    pop bx
    pop ax
    ret
	
; TIMER ISR - Handles multitasking
timer_isr:
    push ax
    push ds
   
    push cs
    pop ds
   
    ; Check if game is actively playing
    cmp byte [game_started], 1
    jne .play_ambient
    cmp byte [show_title_screen], 1
    je .play_ambient
    cmp byte [show_gameover_popup], 1
    je .play_ambient
    cmp byte [show_stats_screen], 1
    je .play_ambient
   
    ; Game is playing - only racing music
    call music_process
    jmp .chain
   
.play_ambient:
    ; Not in gameplay - only ambient
    call ambient_sound_process

.chain:    ; ← ADD THIS LABEL HERE
    pop ds
    pop ax
   
    ; Chain to old timer
    jmp far [cs:old_timer_isr]

; Hook timer interrupt
hook_timer:
    push es
    push ax
    push bx
   
    ; Save old timer ISR (INT 0x08)
    xor ax, ax
    mov es, ax
    cli
   
    mov ax, [es:0x08*4]
    mov [old_timer_isr], ax
    mov ax, [es:0x08*4+2]
    mov [old_timer_isr+2], ax
   
    ; Install new timer ISR
    mov word [es:0x08*4], timer_isr
    mov word [es:0x08*4+2], cs
   
    sti
    pop bx
    pop ax
    pop es
    ret

; Unhook timer interrupt
unhook_timer:
    push es
    push ax
   
    xor ax, ax
    mov es, ax
    cli
   
    ; Restore old timer ISR
    mov ax, [old_timer_isr]
    mov [es:0x08*4], ax
    mov ax, [old_timer_isr+2]
    mov [es:0x08*4+2], ax
   
    sti
    pop ax
    pop es
    ret
delay:
    push cx
    push dx
   
    ; Check which screen we're on
    cmp byte [show_title_screen], 1
    je .title_delay
   
    ; Normal game delay
    mov cx, 2
.outer:
    push cx
    mov cx, 0xFFFF
.inner:
    nop
    loop .inner
    pop cx
    loop .outer
    jmp .done
   
.title_delay:
    ; Much shorter delay for title screen animation
    mov cx, 2
.title_outer:
    push cx
    mov cx, 0x1FFF ;0x3FFF
.title_inner:
    nop
    loop .title_inner
    pop cx
    loop .title_outer
   
.done:
    pop dx
    pop cx
    ret

clrscr:
    push es
    push ax
    push di
    push cx
    mov ax, [screen_seg]
    mov es, ax
    xor di, di
    mov cx, 2000
    mov ax, 0x0020
    rep stosw
    pop cx
    pop di
    pop ax
    pop es
    ret

print_str_at:
    push es
    push di
    push ax
    push bx
    push dx
    push cx
    mov dx, [screen_seg]
    mov es, dx
    call xy_to_di
    pop cx
    mov ah, cl
.loop:
    lodsb
    cmp al, 0
    je .done
    mov [es:di], ax
    add di, 2
    jmp .loop
.done:
    pop dx
    pop bx
    pop ax
    pop di
    pop es
    ret

draw_box_at:
    push bp
    mov bp, sp
    push es
    push di
    push ax
    push bx
    push cx
    push dx
    mov ax, [screen_seg]
    mov es, ax
    mov dx, [bp+10]
    mov bx, [bp+8]
    mov cx, [bp+6]
    push dx
    push cx
.fill_outer:
    mov ax, dx
    push bx
    call xy_to_di
    pop bx
    push cx
    mov cx, [bp+4]
.fill_inner:
    mov word [es:di], 0x1F20
    add di, 2
    loop .fill_inner
    pop cx
    inc dx
    loop .fill_outer
    pop cx
    pop dx
    mov ax, dx
    push bx
    call xy_to_di
    pop bx
    mov word [es:di], 0x1FDA
    add di, 2
    push cx
    mov cx, [bp+4]
    sub cx, 2
.top_border:
    mov word [es:di], 0x1FC4
    add di, 2
    loop .top_border
    mov word [es:di], 0x1FBF
    pop cx
    push dx
    push cx
    sub cx, 2
    inc dx
.side_border:
    mov ax, dx
    push bx
    call xy_to_di
    pop bx
    mov word [es:di], 0x1FB3
    push ax
    push bx
    mov ax, dx
    add bx, [bp+4]
    dec bx
    call xy_to_di
    mov word [es:di], 0x1FB3
    pop bx
    pop ax
    inc dx
    loop .side_border
    pop cx
    pop dx
    mov ax, dx
    add ax, cx
    dec ax
    push bx
    call xy_to_di
    pop bx
    mov word [es:di], 0x1FC0
    add di, 2
    push cx
    mov cx, [bp+4]
    sub cx, 2
.bottom_border:
    mov word [es:di], 0x1FC4
    add di, 2
    loop .bottom_border
    mov word [es:di], 0x1FD9
    pop cx
    pop dx
    pop cx
    pop bx
    pop ax
    pop di
    pop es
    pop bp
    ret 8

draw_input_screen:
    pusha
    call clrscr
   
    ; Set background color
    mov ax, 0x0600
    mov bh, 0x1F
    mov cx, 0
    mov dx, 0x184F
    int 0x10
   
    ; Title
    mov ax, 8
    mov bx, 30
    mov cl, 0x1E
    mov si, input_title
    call print_str_at
   
    ; Name label
    mov ax, 11
    mov bx, 20
    mov cl, 0x1F
    mov si, input_name
    call print_str_at
   
    ; Draw name field background
    mov ax, [screen_seg]
    mov es, ax
    mov ax, 11
    mov bx, 26
    call xy_to_di
    mov cx, 20
    cmp byte [input_field], 0
    jne .name_bg_normal
    mov ah, 0x70
    jmp .name_bg_draw
.name_bg_normal:
    mov ah, 0x0F
.name_bg_draw:
    mov al, '_'
.name_bg_loop:
    mov [es:di], ax
    add di, 2
    loop .name_bg_loop
   
    ; Print name text
    mov ax, 11
    mov bx, 26
    call xy_to_di
    mov si, player_name
    cmp byte [input_field], 0
    jne .name_txt_normal
    mov ah, 0x70
    jmp .name_txt_draw
.name_txt_normal:
    mov ah, 0x0F
.name_txt_draw:
.name_txt_loop:
    lodsb
    cmp al, 0
    je .name_txt_done
    mov [es:di], ax
    add di, 2
    jmp .name_txt_loop
.name_txt_done:
   
    ; Roll label
    mov ax, 13
    mov bx, 17
    mov cl, 0x1F
    mov si, input_roll
    call print_str_at
   
    ; Draw roll field background
    mov ax, 13
    mov bx, 26
    call xy_to_di
    mov cx, 15
    cmp byte [input_field], 1
    jne .roll_bg_normal
    mov ah, 0x70
    jmp .roll_bg_draw
.roll_bg_normal:
    mov ah, 0x0F
.roll_bg_draw:
    mov al, '_'
.roll_bg_loop:
    mov [es:di], ax
    add di, 2
    loop .roll_bg_loop
   
    ; Print roll text
    mov ax, 13
    mov bx, 26
    call xy_to_di
    mov si, player_roll
    cmp byte [input_field], 1
    jne .roll_txt_normal
    mov ah, 0x70
    jmp .roll_txt_draw
.roll_txt_normal:
    mov ah, 0x0F
.roll_txt_draw:
.roll_txt_loop:
    lodsb
    cmp al, 0
    je .roll_txt_done
    mov [es:di], ax
    add di, 2
    jmp .roll_txt_loop
.roll_txt_done:
   
    ; Instructions
    mov ax, 16
    mov bx, 27
    mov cl, 0x1E
    mov si, input_instr
    call print_str_at
   
    popa
    ret

draw_instructions:
    pusha
    call clrscr
    push word 6
    push word 18
    push word 13
    push word 44
    call draw_box_at
    mov ax, 8
    mov bx, 30
    mov cl, 0x1E
    mov si, instr_title
    call print_str_at
    mov ax, 11
    mov bx, 22
    mov cl, 0x1F
    mov si, instr_1
    call print_str_at
    mov ax, 12
    mov bx, 22
    mov cl, 0x1F
    mov si, instr_2
    call print_str_at
    mov ax, 13
    mov bx, 22
    mov cl, 0x1F
    mov si, instr_3
    call print_str_at
    mov ax, 14
    mov bx, 22
    mov cl, 0x1F
    mov si, instr_4
    call print_str_at
    mov ax, 16
    mov bx, 24
    mov cl, 0x1E
    mov si, instr_press
    call print_str_at
    popa
    ret

draw_gameover_popup:
    pusha
    push word 7
    push word 20
    push word 11
    push word 40
    call draw_box_at
    mov ax, 9
    mov bx, 35
    mov cl, 0x1C
    mov si, gameover_msg
    call print_str_at
    mov ax, 11
    mov bx, 25
    mov cl, 0x1F
    cmp byte [end_reason], 0
    jne .check_fuel
    mov si, reason_quit
    jmp .print_reason
.check_fuel:
    cmp byte [end_reason], 1
    jne .crash
    mov si, reason_fuel
    jmp .print_reason
.crash:
    mov si, reason_crash
.print_reason:
    call print_str_at
    mov ax, 15
    mov bx, 26
    mov cl, 0x1E
    mov si, presskey_msg
    call print_str_at
    popa
    ret

draw_stats_screen:
    pusha
    call clrscr
    push word 5
    push word 15
    push word 15
    push word 50
    call draw_box_at
    mov ax, 7
    mov bx, 35
    mov cl, 0x1C
    mov si, gameover_msg
    call print_str_at
    mov ax, 10
    mov bx, 20
    mov cl, 0x1F
    mov si, name_label
    call print_str_at
    mov ax, 10
    mov bx, 26
    mov cl, 0x1E
    mov si, player_name
    call print_str_at
    mov ax, 12
    mov bx, 17
    mov cl, 0x1F
    mov si, roll_label
    call print_str_at
    mov ax, 12
    mov bx, 26
    mov cl, 0x1E
    mov si, player_roll
    call print_str_at
    mov ax, 14
    mov bx, 19
    mov cl, 0x1F
    mov si, coins_label
    call print_str_at
    mov ax, [screen_seg]
    mov es, ax
    mov ax, 14
    mov bx, 26
    call xy_to_di
    mov ax, [coins_collected]
    call print_number
    mov ax, 14
    mov bx, 35
    mov cl, 0x1F
    mov si, score_label
    call print_str_at
    mov ax, 14
    mov bx, 42
    call xy_to_di
    mov ax, [score]
    call print_number
    mov ax, 17
    mov bx, 30
    mov cl, 0x1B
    mov si, stats_instr1
    call print_str_at
    mov ax, 18
    mov bx, 32
    mov cl, 0x1B
    mov si, stats_instr2
    call print_str_at
    popa
    ret

draw_confirmation:
    pusha
    push word 8
    push word 20
    push word 9
    push word 40
    call draw_box_at
    mov ax, 11
    mov bx, 30
    mov cl, 0x1F
    mov si, quit_msg
    call print_str_at
    mov ax, 13
    mov bx, 32
    mov cl, 0x1E
    mov si, yn_msg
    call print_str_at
    popa
    ret

draw_title_screen:
    pusha
   
    ; Check if this is first time (initialize)
    cmp word [title_frame], 0
    jne .animate
   
    ; First time - set up everything
    ; Set dark blue background
    mov ax, 0x0600
    mov bh, 0x11
    mov cx, 0
    mov dx, 0x184F
    int 0x10
   
    ; Initialize stars
    call init_title_stars
   
    ; Draw CRASH title
    call draw_crash_title
   
    ; Draw highway
    call draw_title_highway
   
    ; Draw car on highway
    call draw_title_car
   
    inc word [title_frame]
   
.animate:
    ; Animate stars and lane dividers
    call animate_title_stars
    call animate_title_lanes
   
    ; Draw "Press any key" message
    mov ax, [screen_seg]
    mov es, ax
    mov ax, 23
    mov bx, 25
    call xy_to_di
    mov si, title_press
    mov ah, 0x1F
.print_press:
    lodsb
    cmp al, 0
    je .print_dev1_setup    
    mov [es:di], ax
    add di, 2
    jmp .print_press

.print_dev1_setup:         
    mov ax, 7
    mov bx, 28
    call xy_to_di
    mov si, developer_1
    mov ah, 0x1E
.print_dev1:
    lodsb
    cmp al, 0
    je .print_dev2_setup
    mov [es:di], ax
    add di, 2
    jmp .print_dev1
   
.print_dev2_setup:
    mov ax, 8
    mov bx, 28
    call xy_to_di
    mov si, developer_2
    mov ah, 0x1E
.print_dev2:
    lodsb
    cmp al, 0
    je .done               
    mov [es:di], ax
    add di, 2
    jmp .print_dev2
   
.done:                    
    popa
    ret


init_title_stars:
    pusha
    ; Initialize 15 stars randomly
    mov cx, 15
    mov si, star1_pos
   
.init_loop:
    push cx
    push si
   
    ; Get random row (1-9 for top area, avoiding title)
    call random
    and al, 0x0F
    cmp al, 6
    jle .row_ok
     mov al, 9

.row_ok:
    cmp al, 1
    jge .row_valid
    mov al, 1
.row_valid:
    mov dh, al
   
    ; Get random column (left or right side)
    call random
    test al, 1
    jz .left_side
   
.right_side:
    ; Right side: 50-79
    call random
    xor dx, dx
    mov cx, 24
    div cx
    add dl, 54
    mov dh, al  ; Restore row from earlier
    jmp .store_star
   
.left_side:
    ; Left side: 0-22
    push dx  ; Save row
    call random
    xor dx, dx
    mov cx, 26
    div cx
    mov cl, dl  ; Save column
    pop dx  ; Restore row
    mov dl, cl  ; Put column in DL
   
.store_star:
    pop si
    mov [si], dx
    add si, 2
    pop cx
    loop .init_loop
   
    ; Draw all stars
    mov cx, 15
    mov si, star1_pos
   
.draw_loop:
    push cx
    push si
    mov dx, [si]
   
    ; Set cursor position
    mov ah, 0x02
    mov bh, 0x00
    int 0x10
   
    ; Draw star
    mov ah, 0x09
    mov al, '*'
    mov bl, 0x1F
    mov cx, 1
    int 0x10
   
    pop si
    add si, 2
    pop cx
    loop .draw_loop
   
    popa
    ret


draw_crash_title:
    pusha
    mov ax, [screen_seg]
    mov es, ax
   
    ; === C ===
    mov ax, 1
    mov bx, 26 ;position
    call xy_to_di
    mov word [es:di], 0x0E2F
    mov word [es:di+2], 0x0E2D
    mov word [es:di+4], 0x0E2D
    mov word [es:di+6], 0x0E2D
   
    mov cx, 3
    mov bx, 2
.c_left:
    mov ax, bx
    push bx
    mov bx, 26
    call xy_to_di
    mov word [es:di], 0x0E7C
    pop bx
    inc bx
    loop .c_left
   
    mov ax, 5
    mov bx, 26
    call xy_to_di
    mov word [es:di], 0x0E5C
    mov word [es:di+2], 0x0E5F
    mov word [es:di+4], 0x0E5F
    mov word [es:di+6], 0x0E2F
   
    ; === R === (column 17, moved left from 22)
    mov ax, 1
    mov bx, 31
    call xy_to_di
    mov word [es:di], 0x0E2F
    mov word [es:di+2], 0x0E2D
    mov word [es:di+4], 0x0E2D
    mov word [es:di+6], 0x0E5C
   
    mov ax, 2
    mov bx, 31
    call xy_to_di
    mov word [es:di], 0x0E7C
    mov word [es:di+6], 0x0E7C
   
    mov ax, 3
    mov bx, 31
    call xy_to_di
    mov word [es:di], 0x0E7C
    mov word [es:di+2], 0x0E2D
    mov word [es:di+4], 0x0E2D
    mov word [es:di+6], 0x0E2F
   
    mov ax, 4
    mov bx, 31
    call xy_to_di
    mov word [es:di], 0x0E7C
    mov word [es:di+4], 0x0E5C
   
    mov ax, 5
    mov bx, 31
    call xy_to_di
    mov word [es:di], 0x0E7C
    mov word [es:di+6], 0x0E5C
   
    ; === A === (column 23, moved left from 28)
    mov ax, 1
    mov bx, 37
    call xy_to_di
    mov word [es:di], 0x0E2F
    mov word [es:di+2], 0x0E2D
    mov word [es:di+4], 0x0E5C
   
    mov ax, 2
    mov bx, 36
    call xy_to_di
    mov word [es:di], 0x0E2F
    mov word [es:di+8], 0x0E5C
   
    mov ax, 3
    mov bx, 36
    call xy_to_di
    mov word [es:di], 0x0E7C
    mov word [es:di+2], 0x0E2D
    mov word [es:di+4], 0x0E2D
    mov word [es:di+6], 0x0E2D
    mov word [es:di+8], 0x0E7C
   
    mov cx, 2
    mov bx, 4
.a_legs:
    mov ax, bx
    push bx
    mov bx, 36
    call xy_to_di
    mov word [es:di], 0x0E7C
    mov word [es:di+8], 0x0E7C
    pop bx
    inc bx
    loop .a_legs
   
    ; === S === (column 28, moved left from 33)
    mov ax, 1
    mov bx, 42
    call xy_to_di
    mov word [es:di], 0x0E2F
    mov word [es:di+2], 0x0E2D
    mov word [es:di+4], 0x0E2D
    mov word [es:di+6], 0x0E2D
   
    mov ax, 2
    mov bx, 42
    call xy_to_di
    mov word [es:di], 0x0E7C
   
    mov ax, 3
    mov bx, 42
    call xy_to_di
    mov word [es:di], 0x0E5C
    mov word [es:di+2], 0x0E2D
    mov word [es:di+4], 0x0E2D
    mov word [es:di+6], 0x0E2F
   
    mov ax, 4
    mov bx, 42
    call xy_to_di
    mov word [es:di+6], 0x0E7C
   
    mov ax, 5
    mov bx, 42
    call xy_to_di
    mov word [es:di], 0x0E2D ;0x0E5C
    mov word [es:di+2], 0x0E2D      ; 0x0E5F
    mov word [es:di+4], 0x0E2D    ;    0x0E5F
    mov word [es:di+6], 0x0E2F
   
    ; === H === (column 33, moved left from 38)
    mov cx, 5
    mov bx, 1
.h_left:
    mov ax, bx
    push bx
    mov bx, 47
    call xy_to_di
    mov word [es:di], 0x0E7C
    pop bx
    inc bx
    loop .h_left
   
    mov ax, 3
    mov bx, 48
    call xy_to_di
    mov word [es:di], 0x0E2D
    mov word [es:di+2], 0x0E2D
   
    mov cx, 5
    mov bx, 1
.h_right:
    mov ax, bx
    push bx
    mov bx, 50
    call xy_to_di
    mov word [es:di], 0x0E7C
    pop bx
    inc bx
    loop .h_right
   
    ; === ! === (column 38, moved left from 43)
    mov cx, 3
    mov bx, 1
.exclaim_bar:
    mov ax, bx
    push bx
    mov bx, 52
    call xy_to_di
    mov word [es:di], 0x0E7C
    pop bx
    inc bx
    loop .exclaim_bar
   
    mov ax, 5
    mov bx, 52
    call xy_to_di
    mov word [es:di], 0x0E2E
   
    popa
    ret

draw_title_highway:
    pusha
    mov ax, [screen_seg]
    mov es, ax
   
    ; Draw black highway (rows 10-24)
    mov cx, 15
    mov bx, 10
.highway_loop:
    push cx
    mov ax, bx
    push bx
   
    ; Calculate left edge
    sub bx, 10
    mov dx, 30
    sub dx, bx
    cmp dx, 0
    jge .left_ok
    xor dx, dx
.left_ok:
   
    ; Calculate right edge
    pop bx
    push bx
    mov ax, bx
    sub ax, 10
    add ax, 50
    cmp ax, 79
    jle .right_ok
    mov ax, 79
.right_ok:
   
    ; Draw highway row
    pop bx
    push bx
    mov ax, bx
    push ax
    mov bx, dx
    call xy_to_di
    pop ax
   
    ; Calculate width
    sub ax, 10
    add ax, 50
    cmp ax, 79
    jle .width_ok
    mov ax, 79
.width_ok:
    sub ax, dx
    inc ax
    mov cx, ax
.fill_row:
    mov word [es:di], 0x0020
    add di, 2
    loop .fill_row
   
    pop bx
    inc bx
    pop cx
    loop .highway_loop
   
    ; Draw center lane divider
    mov byte [lane_offset], 0
    call draw_title_center_line
   
    popa
    ret

draw_title_center_line:
    pusha
    mov ax, [screen_seg]
    mov es, ax
   
    mov cx, 15
    mov bx, 10
.line_loop:
    mov ax, bx
    push bx
    mov bl, [lane_offset]
    add al, bl
    and al, 0x03
    pop bx
   
    cmp al, 0
    je .draw
    cmp al, 1
    je .draw
    jmp .skip
   
.draw:
    mov ax, bx
    push bx
    mov bx, 40
    call xy_to_di
    mov word [es:di], 0x0E7C
    pop bx
   
.skip:
    inc bx
    loop .line_loop
   
    popa
    ret

draw_title_car:
    pusha
    mov ax, [screen_seg]
    mov es, ax
   
    ; Row 0 - Hood
    mov ax, 18
    mov bx, 28
    call xy_to_di
    mov word [es:di], 0x0FFE
    mov word [es:di+2], 0x0CDF
    mov word [es:di+4], 0x0CDF
    mov word [es:di+6], 0x0CDF
    mov word [es:di+8], 0x0CDF
    mov word [es:di+10], 0x0FFE
   
    ; Row 1 - Windshield
    mov ax, 19
    mov bx, 28
    call xy_to_di
    mov word [es:di], 0x0CDB
    mov word [es:di+2], 0x09DB
    mov word [es:di+4], 0x09DB
    mov word [es:di+6], 0x09DB
    mov word [es:di+8], 0x09DB
    mov word [es:di+10], 0x0CDB
   
    ; Row 2 - Body
    mov ax, 20
    mov bx, 27
    call xy_to_di
    mov word [es:di], 0x0CDB
    mov word [es:di+2], 0x0CDB
    mov word [es:di+4], 0x0CB3
    mov word [es:di+6], 0x0CDB
    mov word [es:di+8], 0x0CDB
    mov word [es:di+10], 0x0CB3
    mov word [es:di+12], 0x0CDB
    mov word [es:di+14], 0x0CDB
   
    ; Row 3 - Lower body
    mov ax, 21
    mov bx, 27
    call xy_to_di
    mov word [es:di], 0x0CDB
    mov word [es:di+2], 0x0CDB
    mov word [es:di+4], 0x0CB3
    mov word [es:di+6], 0x0CDB
    mov word [es:di+8], 0x0CDB
    mov word [es:di+10], 0x0CB3
    mov word [es:di+12], 0x0CDB
    mov word [es:di+14], 0x0CDB
   
    ; Row 4 - Tires
    mov ax, 22
    mov bx, 27
    call xy_to_di
    mov word [es:di], 0x08FE
    mov word [es:di+2], 0x0CDC
    mov word [es:di+4], 0x0CDC
    mov word [es:di+6], 0x0CDC
    mov word [es:di+8], 0x0CDC
    mov word [es:di+10], 0x0CDC
    mov word [es:di+12], 0x0CDC
    mov word [es:di+14], 0x08FE
   
    popa
    ret

animate_title_stars:
    pusha
   
    ; Only animate every 8 frames to make it slower
    mov ax, [title_frame]
    and ax, 0x07
    jnz .skip_animation
   
    mov ax, [screen_seg]
    mov es, ax
   
    ; Animate all 15 stars
    mov cx, 15
    mov si, star1_pos
   
.star_loop:
    push cx
    push si
   
    mov dx, [si]
   
    ; Clear old position
    push dx
    mov ah, 0x02
    mov bh, 0x00
    int 0x10
    mov ah, 0x09
    mov al, ' '
    mov bl, 0x11
    mov cx, 1
    int 0x10
    pop dx
   
    ; Move star down
    inc dh
   
    ; Check if star hit CRASH title (rows 1-5, columns 23-49)
    cmp dh, 1
    jl .no_title_collision
    cmp dh, 6
    jge .no_title_collision
   
    ; Check if in title column range
    cmp dl, 23
    jl .no_title_collision
    cmp dl, 49
    jg .no_title_collision
   
    ; Star hit title - move to row 6 (below title)
    mov dh, 6
   
.no_title_collision:
    ; Check if star hit highway (row 10+)
    cmp dh, 10
    jl .draw_star
   
    ; Check if star is on the highway using the helper function
    push si
    call is_on_highway
    pop si
   
    cmp al, 1
    je .reset_star  ; Star hit highway, reset it
   
    ; Star is beside highway, check if reached bottom
    cmp dh, 25
    jge .reset_star
   
.draw_star:
    ; Draw star at new position
    push dx
    mov ah, 0x02
    mov bh, 0x00
    int 0x10
    mov ah, 0x09
    mov al, '*'
    mov bl, 0x1F
    mov cx, 1
    int 0x10
    pop dx
   
    ; Save new position
    pop si
    mov [si], dx
    add si, 2
    pop cx
    dec cx
    jnz .star_loop
    jmp .done
   
.reset_star:
    ; Save current column to determine side
    mov bl, dl
   
    ; Reset to top row
    mov dh, 1
   
    ; Determine which side to reset to based on current column
    cmp bl, 40
    jge .reset_right
   
.reset_left:
    ; Left side (0-22)
    push cx
    call random
    xor dx, dx
    mov cx, 26
    div cx
    mov dh, 1; Set row back to 1
    pop cx
    jmp .draw_new
   
.reset_right:
    ; Right side (50-79)
    push cx
    call random
    xor dx, dx
    mov cx, 27
    div cx
    add dl, 53
    mov dh, 1 ; Set row back to 1
    pop cx
   
.draw_new:
    ; Draw star at new position
    push dx
    mov ah, 0x02
    mov bh, 0x00
    int 0x10
    mov ah, 0x09
    mov al, '*'
    mov bl, 0x1F
    mov cx, 1
    int 0x10
    pop dx
   
    ; Save position
    pop si
    mov [si], dx
    add si, 2
    pop cx
    dec cx
    jnz .star_loop
   
.skip_animation:
.done:
    popa
    ret


is_on_highway:
    ; Check if position DH=row, DL=col is on the highway
    ; Returns AL=1 if on highway, AL=0 otherwise
   
    push bx
    push cx
   
    ; Check if row < 10 (not on highway yet)
    cmp dh, 10
    jl .not_highway
   
    ; Check if row > 24 (past highway)
    cmp dh, 24
    jg .not_highway
   
    ; Calculate left edge column: 30 - (row - 10)
    xor ax, ax
    mov al, dh
    sub al, 10
    mov bl, 30
    sub bl, al      ; BL = left column
   
    ; Clamp left edge to 0
    cmp bl, 0
    jge .left_ok
    xor bl, bl
.left_ok:
   
    ; Calculate right edge column: 50 + (row - 10)
    xor ax, ax
    mov al, dh
    sub al, 10
    add al, 50      ; AL = right column
   
    ; Clamp right edge to 79
    cmp al, 79
    jle .right_ok
    mov al, 79
.right_ok:
   
    ; Check if column is between left and right edge
    cmp dl, bl
    jl .not_highway
    cmp dl, al
    jg .not_highway
   
    ; On highway
    mov al, 1
    pop cx
    pop bx
    ret
   
.not_highway:
    xor al, al
    pop cx
    pop bx
    ret

; Replace animate_title_lanes function - slower animation
animate_title_lanes:
    pusha
   
    ; Only animate every 4 frames to make it slower
    mov ax, [title_frame]
    and ax, 0x03
    jnz .skip_animation
   
    ; Clear old lane divider
    mov ax, [screen_seg]
    mov es, ax
    mov cx, 15
    mov bx, 10
.clear_loop:
    mov ax, bx
    push bx
    mov bx, 40
    call xy_to_di
    mov word [es:di], 0x0020
    pop bx
    inc bx
    loop .clear_loop
   
    ; Update offset
    mov al, [lane_offset]
    inc al
    and al, 0x03
    mov [lane_offset], al
   
    ; Draw new lane divider
    call draw_title_center_line
   
.skip_animation:
    popa
    ret

kbisr:
    push ax
    push bx
    push ds
    push cs
    pop ds
    in al, 0x60
    test al, 0x80
    jnz .key_release
    cmp byte [show_confirmation], 1
    jne .not_confirm
    cmp al, 0x15
    je .do_quit
    cmp al, 0x31
    je .do_resume
    cmp al, 0x01
    je .do_resume
    jmp .done
.do_quit:
    ; Check if game has started
    cmp byte [game_started], 1
    je .quit_during_game
   
    ; Quit before game started - turn off all screens and exit
    mov byte [game_paused], 1
    mov byte [show_confirmation], 0
    mov byte [show_input_screen], 0      
    mov byte [show_instructions], 0      
    mov byte [show_title_screen], 0     
    jmp .done

.quit_during_game:
    ; Normal quit during gameplay
    mov byte [game_paused], 1
    mov byte [show_confirmation], 0
    mov byte [confirm_drawn], 0
    jmp .done
.do_resume:
    mov byte [show_confirmation], 0
    mov byte [confirm_drawn], 0
   
    ; Simply reset the redraw flag for whichever screen is currently active
    cmp byte [show_stats_screen], 1
    je .reset_stats
    cmp byte [show_instructions], 1
    je .reset_instr
    cmp byte [show_input_screen], 1
    je .reset_input
    cmp byte [show_waiting_screen], 1
    je .reset_waiting
    jmp .done

.reset_stats:
    mov byte [gameover_drawn], 0
    jmp .done

.reset_instr:
    mov byte [instr_drawn], 0
    jmp .done

.reset_input:
    mov byte [input_drawn], 0
    jmp .done

.reset_waiting:
    mov byte [gameover_drawn], 0
    jmp .done
.not_confirm:
    cmp byte [show_title_screen], 1
    jne .not_title
   
   
    mov byte [show_title_screen], 0
    mov byte [show_input_screen], 1
    jmp .done

.title_esc:
  mov byte [show_title_screen], 0
    mov byte [show_confirmation], 1
    mov byte [confirm_drawn], 0
    jmp .done
.not_title:
    cmp byte [show_input_screen], 1
    jne .not_input
    mov byte [input_drawn], 0
    mov byte [instr_drawn], 0
    cmp al, 0x0F
    je .input_tab
    cmp al, 0x1C
    je .input_enter
    cmp al, 0x0E
    je .input_backspace
cmp al, 0x01              ;  ESC key
    je .input_esc    
    jmp .input_char

.input_esc:
    ; DON'T turn off show_input_screen - keep it for restoration
    mov byte [show_confirmation], 1
    mov byte [confirm_drawn], 0
    jmp .done
.input_tab:
    xor byte [input_field], 1
    jmp .done
.input_enter:
    cmp byte [player_name], 0
    je .done
    cmp byte [player_roll], 0
    je .done
    mov byte [show_input_screen], 0
    mov byte [show_instructions], 1
    jmp .done
.input_backspace:
    cmp byte [input_field], 0
    jne .bs_roll
    cmp byte [name_pos], 0
    je .done
    dec byte [name_pos]
    xor bx, bx
    mov bl, [name_pos]
    mov byte [player_name+bx], 0
    jmp .done
.bs_roll:
    cmp byte [roll_pos], 0
    je .done
    dec byte [roll_pos]
    xor bx, bx
    mov bl, [roll_pos]
    mov byte [player_roll+bx], 0
    jmp .done
.input_char:
    xor bx, bx
    mov bl, al
    mov al, [scancode_to_ascii+bx]
    cmp al, 0
    je .done
    cmp byte [input_field], 0
    jne .char_roll
    cmp byte [name_pos], 20
    jge .done
    xor bx, bx
    mov bl, [name_pos]
    mov [player_name+bx], al
    inc byte [name_pos]
    mov byte [player_name+bx+1], 0
    jmp .done
.char_roll:
    cmp byte [roll_pos], 15
    jge .done
    xor bx, bx
    mov bl, [roll_pos]
    mov [player_roll+bx], al
    inc byte [roll_pos]
    mov byte [player_roll+bx+1], 0
    jmp .done

.not_input:
    cmp byte [show_waiting_screen], 1
    jne .not_waiting
   
    ; Any key on waiting screen starts the game
    mov byte [show_waiting_screen], 0
    mov byte [gameover_drawn], 0
    mov byte [game_started], 1
    jmp .done

.not_waiting:
    cmp byte [show_instructions], 1
    jne .not_instr_check
   
    ; Check if ESC was pressed
    cmp al, 0x01
    je .instr_esc
   
    ; Any other key closes instructions and shows waiting screen
    mov byte [show_instructions], 0
    mov byte [instr_drawn], 0
    mov byte [show_waiting_screen], 1
    mov byte [gameover_drawn], 0
    jmp .done

.instr_esc:
    ; Show confirmation dialog
    mov byte [show_confirmation], 1
    mov byte [confirm_drawn], 0
    jmp .done

.not_instr_check:
    cmp byte [show_stats_screen], 1
    jne .not_stats
    cmp al, 0x39
    je .stats_replay
    cmp al, 0x01
    je .stats_esc
    jmp .done

.stats_replay:
    mov byte [show_stats_screen], 0
    mov byte [game_started], 0
    mov byte [gameover_drawn], 0
    mov byte [show_title_screen], 1
    call reset_game_state
    jmp .done

.stats_esc:
    mov byte [show_confirmation], 1
    mov byte [confirm_drawn], 0
    jmp .done

.not_stats:
    cmp byte [show_gameover_popup], 1
    jne .not_gameover
    mov byte [show_gameover_popup], 0
    mov byte [gameover_drawn], 0         
    mov byte [show_stats_screen], 1
    jmp .done
.not_gameover:
    cmp byte [game_started], 0
    jne .game_running
    mov byte [game_started], 1
    mov byte [gameover_drawn], 0  ; Reset the flag when game starts
    jmp .done
.game_running:
    cmp al, 0x10
    je .game_q
    cmp al, 0x01
    je .game_esc
    cmp al, 0x4B
    je .game_left
    cmp al, 0x4D
    je .game_right
    cmp al, 0x48          ; UP arrow scancode
    je .game_up
    cmp al, 0x50          ; DOWN arrow scancode
    je .game_down
    jmp .done
.game_q:
    mov byte [end_reason], 0
    mov byte [show_gameover_popup], 1
    jmp .done
.game_esc:
    mov byte [show_confirmation], 1
    mov byte [confirm_drawn], 0
    jmp .done
.game_left:
    cmp word [lane_change_cooldown], 0    ; Check if cooldown active
    jne .done                              ; If still cooling down, ignore input
    cmp byte [key_left_pressed], 0
    jne .done
    mov byte [key_left_pressed], 1
    call move_player_left
    mov ax, [lane_change_delay]           ; Set the cooldown
    mov [lane_change_cooldown], ax
    jmp .done
.game_right:
    cmp word [lane_change_cooldown], 0    ; Check if cooldown active
    jne .done                              ; If still cooling down, ignore input
    cmp byte [key_right_pressed], 0
    jne .done
    mov byte [key_right_pressed], 1
    call move_player_right
    mov ax, [lane_change_delay]           ; Set the cooldown
    mov [lane_change_cooldown], ax
    jmp .done

.game_up:
    cmp byte [key_up_pressed], 0
    jne .done
    mov byte [key_up_pressed], 1
    call move_player_up
    jmp .done
.game_down:
    cmp byte [key_down_pressed], 0
    jne .done
    mov byte [key_down_pressed], 1
    call move_player_down
    jmp .done
.key_release:
    and al, 0x7F
    cmp al, 0x4B
    jne .not_left_rel
    mov byte [key_left_pressed], 0
    jmp .done
.not_left_rel:
    cmp al, 0x4D
    jne .not_right_rel         
    mov byte [key_right_pressed], 0
    jmp .done                   
.not_right_rel:                
    cmp al, 0x48                
    jne .not_up_rel
    mov byte [key_up_pressed], 0
    jmp .done
.not_up_rel:
    cmp al, 0x50                
    jne .done
    mov byte [key_down_pressed], 0
.done:
    push ax
    mov al, 0x20
    out 0x20, al
    pop ax
    pop ds
    pop bx
    pop ax
    iret

reset_game_state:
    push ax
    mov word [score], 0
    mov word [coins_collected], 0
    mov word [fuel_level], 100
    mov word [frame_count], 0
    mov word [lane_scroll], 0
    mov word [lane_change_cooldown], 0
    mov word [music_index], 0        
    mov word [music_tick_counter], 0

    mov word [ambient_note_index], 0
    mov word [ambient_tick_counter], 0
    mov byte [game_over], 0
    mov byte [show_confirmation], 0
    mov byte [show_gameover_popup], 0
    mov byte [gameover_drawn], 0
    mov byte [confirm_drawn], 0
    mov word [title_frame], 0
    mov word [player_row], 20
    mov ax, [lane_center_col]
    mov [player_col], ax
    mov byte [player_lane], 1
    mov byte [obstacle_active], 1
    mov word [obstacle_row], -3
    mov ax, [lane_left_col]
    mov [obstacle_col], ax
    mov byte [obstacle_lane], 0
    mov byte [coin_active], 0
    mov word [coin_row], -3
    mov byte [fuel_active], 0
    mov word [fuel_row], -1
    mov word [rows_since_obstacle], 0
    mov word [rows_since_coin], 20
    mov word [rows_since_fuel], 0
   mov byte [key_left_pressed], 0
    mov byte [key_right_pressed], 0
  mov byte [key_up_pressed], 0     
    mov byte [key_down_pressed], 0   

    pop ax
    ret

update_score_fuel:
    push ax
    mov ax, [frame_count]
    and ax, 0x03       ; Change to smaller for faster
                       
    jnz .done
    inc word [score]
    cmp word [fuel_level], 0
    je .done
    dec word [fuel_level]
.done:
    pop ax
    ret

hook_keyboard:
    push es
    push ax
    push bx
    xor ax, ax
    mov es, ax
    cli
    mov ax, [es:9*4]
    mov [old_kbd_isr], ax
    mov ax, [es:9*4+2]
    mov [old_kbd_isr+2], ax
    mov word [es:9*4], kbisr
    mov word [es:9*4+2], cs
    sti
    pop bx
    pop ax
    pop es
    ret

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

init_game:
    push ax
call stop_sound                 

    mov word [score], 0
    mov word [coins_collected], 0
    mov word [fuel_level], 100
    mov word [frame_count], 0

    mov word [lane_scroll], 0
mov byte [music_enabled], 1
    mov word [music_index], 0        
     mov word [music_tick_counter], 0 

mov byte [ambient_sound_enabled], 1
    mov word [ambient_note_index], 0
    mov word [ambient_tick_counter], 0
    mov byte [game_started], 0
    mov byte [game_paused], 0
    mov byte [game_over], 0
    mov byte [show_confirmation], 0
    mov byte [show_input_screen], 0
    mov byte [show_instructions], 0
    mov byte [show_title_screen], 1
    mov byte [show_gameover_popup], 0
    mov byte [show_stats_screen], 0
mov byte [gameover_drawn], 0
    mov byte [confirm_drawn], 0
    mov byte [input_field], 0
    mov byte [name_pos], 0
    mov byte [roll_pos], 0
    mov byte [key_left_pressed], 0
    mov byte [key_right_pressed], 0
mov byte [key_up_pressed], 0      
    mov byte [key_down_pressed], 0   
    mov word [player_row], 20
    mov ax, [lane_center_col]
    mov [player_col], ax
    mov byte [player_lane], 1
    mov byte [obstacle_active], 1
    mov word [obstacle_row], -3
    mov ax, [lane_left_col]
    mov [obstacle_col], ax
    mov byte [obstacle_lane], 0
    mov byte [coin_active], 0
    mov word [coin_row], -3
    mov byte [fuel_active], 0
    mov word [fuel_row], -1
    mov word [rows_since_obstacle], 0
    mov word [rows_since_coin], 20
    mov word [rows_since_fuel], 0
    pop ax
    ret

game_update:
    ; *** CHECK AT THE VERY TOP - SKIP EVERYTHING IF GAMEOVER ***
    cmp byte [show_gameover_popup], 1
    je .skip_update
   
    ; Decrement lane change cooldown
    cmp word [lane_change_cooldown], 0
    je .cooldown_zero
    dec word [lane_change_cooldown]
   
.cooldown_zero:
    ; *** CHECK IF FUEL HIT ZERO ***
    cmp word [fuel_level], 0
    jne .fuel_ok
    ; Fuel is zero - end game
    mov byte [end_reason], 1
    mov byte [show_gameover_popup], 1
    jmp .skip_update
   
.fuel_ok:
    ; Continue normal game update
    call update_obstacle
    call update_coin
    call update_fuel
    call check_collision
    call check_coin_collection
    call check_fuel_collection
    call spawn_obstacle
    call spawn_coin
    call spawn_fuel
    inc word [lane_scroll]
    inc word [frame_count]
    call update_score_fuel
   
.skip_update:
    ret
game_draw:

 cmp byte [show_gameover_popup], 1
    je .skip_draw
    call draw_background
    call draw_player
    call draw_obstacle
    call draw_coin
    call draw_fuel
    call draw_fuel_bar
    call display_score
    ret
.skip_draw:
    ret
game_loop:
.loop:
    cmp byte [game_paused], 1
    je .exit
    cmp byte [show_confirmation], 1
    je .do_confirm
    cmp byte [show_waiting_screen], 1
    je .do_waiting
    cmp byte [show_title_screen], 1
    je .do_title
    cmp byte [show_input_screen], 1
    je .do_input
    cmp byte [show_instructions], 1
    je .do_instructions
    cmp byte [show_stats_screen], 1
    je .do_stats
    cmp byte [show_gameover_popup], 1
    je .do_gameover
   
    ; The actual gameplay!
    cmp byte [game_started], 1
    jne .loop
    call game_update
    call game_draw
    call delay
    jmp .loop
   
.do_title:
    call draw_title_screen
    inc word [title_frame]
    call delay
    jmp .loop
   
.do_input:
    cmp byte [input_drawn], 0
    jne .input_skip_draw
    call draw_input_screen
    mov byte [input_drawn], 1
.input_skip_draw:
    call delay
    jmp .loop
   
.do_instructions:
    cmp byte [instr_drawn], 0
    jne .instr_skip_draw
    call draw_instructions
    mov byte [instr_drawn], 1
.instr_skip_draw:
    call delay
    jmp .loop

.do_waiting:
    cmp byte [gameover_drawn], 0
    jne .waiting_skip_draw
   
    ; Draw background with "Press any key to START" message
    call draw_background
    mov ax, [screen_seg]
    mov es, ax
    mov ax, 12
    mov bx, 28
    call xy_to_di
    mov si, start_msg
    mov ah, 0x0F
.waiting_loop:
    lodsb
    cmp al, 0
    je .waiting_done
    mov [es:di], ax
    add di, 2
    jmp .waiting_loop
.waiting_done:
    mov byte [gameover_drawn], 1
   
.waiting_skip_draw:
    call delay
    jmp .loop
   
.do_stats:
    cmp byte [gameover_drawn], 0
    jne .stats_skip_draw
   
    call draw_stats_screen
    mov byte [gameover_drawn], 1
   
.stats_skip_draw:
    ; Always redraw stats screen if confirmation is showing
    cmp byte [show_confirmation], 1
    jne .stats_no_confirm
   
    ; Redraw stats before confirmation
    cmp byte [confirm_drawn], 0
    jne .stats_confirm_drawn
    call draw_stats_screen
    call draw_confirmation
    mov byte [confirm_drawn], 1
    jmp .stats_no_confirm
   
.stats_confirm_drawn:
    ; Keep confirmation visible
    call draw_stats_screen
    call draw_confirmation
   
.stats_no_confirm:
    call delay
    jmp .loop
   
.do_gameover:
    cmp byte [gameover_drawn], 0
    jne .gameover_skip_draw
   
    ; Draw the final game state ONCE
    call draw_background
    call draw_player
    call draw_obstacle
    call draw_coin
    call draw_fuel
    call draw_fuel_bar
    call display_score
   
    ; Now draw popup over it
    call draw_gameover_popup
    mov byte [gameover_drawn], 1
   
.gameover_skip_draw:
    call delay
    jmp .loop
   
.do_confirm:
    cmp byte [confirm_drawn], 0
    jne .confirm_skip_draw
   
    ; Redraw the active screen before confirmation
    cmp byte [show_stats_screen], 1
    je .confirm_stats
    cmp byte [show_instructions], 1
    je .confirm_instr
    cmp byte [show_input_screen], 1
    je .confirm_input
    cmp byte [show_waiting_screen], 1
    je .confirm_waiting
   
    ; Only draw game if it has started
    cmp byte [game_started], 1
    jne .confirm_no_game
    call game_draw
    jmp .confirm_no_game

.confirm_stats:
    call draw_stats_screen
    jmp .confirm_no_game

.confirm_instr:
    call draw_instructions
    jmp .confirm_no_game

.confirm_input:
    call draw_input_screen
    jmp .confirm_no_game

.confirm_waiting:
    call draw_background
    mov ax, [screen_seg]
    mov es, ax
    mov ax, 12
    mov bx, 28
    call xy_to_di
    mov si, start_msg
    mov ah, 0x0F
.confirm_waiting_loop:
    lodsb
    cmp al, 0
    je .confirm_no_game
    mov [es:di], ax
    add di, 2
    jmp .confirm_waiting_loop

.confirm_no_game:
    call draw_confirmation
    mov byte [confirm_drawn], 1

.confirm_skip_draw:
    call delay
    jmp .loop
   
.exit:
    ; Check if we should truly exit program
    cmp byte [game_started], 0
    je .true_exit           ; Never started, exit program
   
    ; Game was running, return normally
    ret

.true_exit:
    ; Clean exit - unhook everything and terminate
    mov byte [game_paused], 1
    ret
	
hide_cursor:
    mov ah, 0x01
    mov cx, 0x2000      ; Hide cursor
    int 0x10
	ret

show_cursor:
    ;Set text mode (resets everything)
    mov ax, 0x0003      ; 80x25 text mode
    int 0x10
    
    ;Show cursor explicitly
    mov ah, 0x01
    mov cx, 0x0607      ; Normal cursor (CH=start line, CL=end line)
    int 0x10
    
    ;Position cursor at top-left
    mov ah, 0x02
    mov bh, 0
    mov dx, 0           ; DH=row 0, DL=col 0
    int 0x10
    
    ;Print a character to force cursor display
    mov ah, 0x0E
    mov al, ' '
    int 0x10
	ret

Start:
    call hide_cursor
    call init_game
    call hook_keyboard
    call hook_timer
    call clrscr
    call game_loop
    call stop_sound
    call unhook_timer
    call unhook_keyboard
	call show_cursor
	
    mov ax, 0x4C00
    int 0x21
