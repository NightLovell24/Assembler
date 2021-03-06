TITLE ЛР_5
;------------------------------------------------------------------------------
;ЛР  №5
;------------------------------------------------------------------------------
; Комп'ютерна архітектура
; ВУЗ:          НТУУ "КПІ"
; Факультет:    ФІОТ
; Курс:          1
; Група:       ІТ-03
;------------------------------------------------------------------------------
; Автор: Дудченко О., Цуканова М., Бублик І.
;
; Дата: 14.04.21
;---------------------------------
IDEAL			; Директива - тип Асемблера tasm 
MODEL small		; Директива - тип моделі пам’яті 
STACK 2048		; Директива - розмір стеку 

DATASEG
array_stack db 3, 4, 5, 8, 4, 2, 2, 9, 3, 9, 9, 9, 9, 3, 9, 9
            db 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7
            db 8, 3, 8, 8, 8, 8, 8, 4, 8, 8, 3, 8, 8, 8, 6, 8
            db 2, 5, 2, 2, 8, 2, 2, 2, 2, 1, 2, 2, 2, 2, 2, 2
            db 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 3, 9, 9
            db 7, 3, 7, 7, 7, 7, 5, 7, 7, 6, 7, 3, 7, 4, 7, 7
            db 3, 8, 3, 8, 8, 8, 8, 8, 8, 9, 8, 8, 8, 3, 8, 8
            db 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 5, 2, 3, 2, 2, 2
            db 9, 9, 9, 9, 9, 3, 3, 9, 9, 9, 9, 9, 9, 9, 9, 9
            db 7, 7, 7, 7, 7, 7, 7, 7, 7, 5, 7, 3, 7, 7, 7, 7
            db 8, 3, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8
            db 2, 4, 3, 2, 2, 2, 2, 2, 5, 2, 2, 2, 2, 2, 2, 2
            db 9, 1, 9, 9, 3, 9, 9, 9, 5, 9, 9, 4, 9, 3, 9, 9
            db 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7
            db 8, 8, 8, 4, 8, 8, 8, 8, 8, 5, 8, 3, 8, 8, 8, 8
            db 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2
LEN DW 256

sasha_birthdate db "11.06.2003"            
marina_birthdate db "04.07.2003"
vanya_birthdate db "24.07.2003"

CODESEG
Start:
    mov ax, @data ; ініціалізація сегменту даних
    mov ds, ax    ; ax -> ds
    mov es, ax    ; ax -> es

;------------сортування--------------
    mov cx, [LEN]   ; cx - рахівник операцій для зовн. циклу, cx = 5    
    dec cx          ; декремент cx 
    call sort       ; викликаємо процедуру сортування

;------------копіювання--------------
    mov cx, 256                 ; кількість повторів 
    call copy_array		; викликаємо процедуру копіювання
   

;-----------додаємо першу дату в стек------
    mov cx, 10			; кількість повторів
    mov bp, 01C1h		; встановлюємо адресу 01C1h
    call set_1			; викликаємо першу процедуру додавання дати

;-----------додаємо другу дату в стек------
    mov cx, 10			; кількість повторів
    mov bp, 01D1h		; встановлюємо адресу 01D1h
    call set_2			; викликаємо другу процедуру додавання дати

;-----------додаємо третю дату в стек-------
    mov cx, 10			; кількість повторів
    mov bp, 01E1h		; встановлюємо адресу 01E1h
    call set_3			; викликаємо третю процедуру додавання дати

;-----------завершення програми--------------
    mov ah, 4ch			
    int 21h			; виклик функції DOS 4ch

;--------------------------------------------Процедура сортування-------------------------------------------         

    PROC sort
        nextscan:                ; do {    // outer loop
            mov bx,cx
            mov si,0 

        nextcomp:

            mov al,[array_stack+si]             ; в al записуємо перший елемент, та той, що йде після нього
            mov dl,[array_stack+si+1]
            cmp al,dl       			; за доп. команди cmp порівнюємо al і dl, якщо значення al - dl != 0, задається флаг ZF = 0

            jc noswap 				; переход, якщо є перенос 

            mov [array_stack+si], dl		; записуємо елементи назад в тому ж порядку
            mov [array_stack+si+1], al

        noswap: 				; використовується, якщо al<dl
            inc si				; інкремент si
            dec bx				; декремент bx
            jnz nextcomp			; умова використання ZF = 0

            loop nextscan			; перевіряємо loop nextscan
        ret					; повернення з процедури
    ENDP
;--------------------------------------------Процедура копіювання-------------------------------------------         
    PROC copy_array       
        xor si, si                       	; обнуляємо si
        array_copy_loop:
            mov bx, [ds:si]              	; отримуємо число з array_stack та встановлюємо його до bx як змінну
            mov [ds:[si+270h]], bx       	; встановлюємо значення з bx до ds 
            add si, 2                    	; збільшуємо значення в регістрі si на 2, оскільки було записано два байти
            loop array_copy_loop	 	; перевірка циклу

        ret				 	; повернення з процедури
    ENDP   

;--------------------------------------------Додаємо першу дату у стек-------------------------------------------         
    PROC set_1       
        xor si,si                                 ; обнуляємо si
        birthdate1_label:
            mov ah, [sasha_birthdate+si]          ; встановлюємо значення ah з sasha_birthdate 
            mov [bp], ah                          ; додаємо значення у стек
            inc si                                ; інкрементуємо si
            inc bp                                ; інкрементуємо bp
            loop birthdate1_label		  ; перевіряємо цикл

        ret					  ; повернення з процедури
    ENDP

;--------------------------------------------Додаємо другу дату у стек-------------------------------------------         
    PROC set_2     
        xor si,si                                 ; обнуляємо si
        birthdate2_label:
            mov ah, [marina_birthdate+si]         ; встановлюємо значення ah з marina_birthdate
            mov [bp], ah                          ; додаємо значення у стек
            inc si                                ; інкрементуємо si
            inc bp                                ; інкрементуємо bp
            loop birthdate2_label		  ; перевіряємо цикл

        ret					  ; повернення з процедури
    ENDP


;--------------------------------------------Додаємо третю дату у стек-------------------------------------------         
    PROC set_3
        xor si,si                                 ; обнуляємо si
        birthdate3_label:
            mov ah, [vanya_birthdate+si]          ; встановлюємо значення ah з vanya_birthdate
            mov [bp], ah                          ; додаємо значення у стек
            inc si                                ; інкрементуємо bp
            inc bp                                ; increment bp
            loop birthdate3_label		  ; перевіряємо цикл

        ret					  ; повернення з процедури
    ENDP

end Start
