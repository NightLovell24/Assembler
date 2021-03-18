TITLE Vihidni kod 2.1
 2 
 
;     
 3 
 
;ЛР №1.2 Кодування Кіріліца Windows-1251
 4 
 
;     
 5 
 
;----------------I.ЗАГОЛОВОК ПРОГРАМИ------------------------
 6 
 
IDEAL
 7 
 
MODEL SMALL 
 8 
 
STACK 512
 9 
 
;    II.МАКРОСИ     
 10 
 
; Складний макрос для ініціалізації
 11 
 
MACRO M_Init        ; Початок макросу 
 12 
 
mov    ax, @data        ; ax <- @data
 13 
 
mov    ds, ax            ; ds <- ax
 14 
 
mov    es, ax            ; es <- ax
 15 
 
ENDM M_Init        ; Кінець макросу
 16 
 
 17 
 
;--------------------III.ПОЧАТОК СЕГМЕНТУ ДАНИХ--------------
 18 
 
DATASEG
 19 
 
;Оголошення двовимірного експериментального масиву 16х16 
 20 
 
array2Db    db  7, 8, 7, 8, 7, 8, 7, 8, 7, 8, 7, 8, 7, 8, 7, 8
 21 
 
            db  8, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 7
 22 
 
            db  7, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 8
 23 
 
            db  8, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 7
 24 
 
            db  7, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 8
 25 
 
            db  8, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 7
 26 
 
            db  7, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 8
 27 
 
            db  66, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 7
 28 
 
            db  8, 73, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 8
 29 
 
            db    7, 0, 86, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 7
 30 
 
            db    8, 0, 0, 68, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 8
 31 
 
            db    7, 0, 0, 0, 65, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 7
 32 
 
            db    8, 0, 0, 0, 0, 65, 0, 0, 0, 0, 0, 0, 0, 0, 0, 8
 33 
 
            db    7, 0, 0, 0, 0, 0, 84, 0, 0, 0, 0, 0, 0, 0, 0, 7
 34 
 
            db    8, 0, 0, 0, 0, 0, 0, 77, 0, 0, 0, 0, 0, 0, 0, 8
 35 
 
            db    7, 8, 7, 8, 7, 8, 7, 8, 83, 8, 7, 8, 7, 8, 7, 7
 36 
 
 37 
 
; Для вирівнювання у дампі 
 38 
 
;arr_def1 dw 3, 0,  0,  0,  0,  0,  0,  0
 39 
 
 40 
 
exCode        DB 0 
 41 
 
;----------------------VI. ПОЧАТОК СЕГМЕНТУ КОДУ-------------------
 42 
 
CODESEG
 43 
 
Start:
 44 
 
    M_Init
 45 
 
    ;Способи адресації по Рудакову-Фiногенову----------------------
 46 
 
     
 47 
 
    ;2. Базова адресація. Призначена для роботи з масивами
 48 
 
 49 
 
    mov al, 02h    ;Число, що буде записано до ділянки дампу
 50 
 
    mov bx, 08h    ;До ВХ заносимо ефективну адресу потрібної ділянки коду 
 51 
 
    mov [bx], al    ;До дампу заносимо значення АХ
 52 
 
    inc bx        ;Збільшуємо значення ВХ на 1 
 53 
 
    mov [bx], al    ;Записуємо в інші ділянки пам’яті
 54 
 
    inc bx
 55 
 
    mov [bx], al    ;Записуємо в інші ділянки пам’яті, все це здійснюється циклічно 
 56 
 
    inc bx
 57 
 
    mov [bx], al    ; 
 58 
 
    inc bx
 59 
 
    mov [bx], al    ; 
 60 
 
    inc bx
 61 
 
    mov [bx], al    ; 
 62 
 
    inc bx
 63 
 
    mov [bx], al    ; 
 64 
 
    inc bx
 65 
 
 66 
 
    mov bp, 01h    ;Етап 1. До ВР заносимо ефективну адресу потрібної ділянки стеку
 67 
 
    mov cx, [bp]    ;Етап 2. До СХ заносимо значення з пам’яті за адресою [SS]:[ВР].
 68 
 
 69 
 
Exit:
 70 
 
    mov ah,4ch
 71 
 
    mov al,[exCode] ;отримання коду виходу
 72 
 
    int 21h
 73 
 
END Start
