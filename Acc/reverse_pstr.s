    .data
.org             0x0
buf:             .byte  '________________________________'
span: 			 .byte '0000'		; т.к я делаю or с underscore, у меня перезаписывался len
len:             .word  0x0
one:             .word  1
cut:             .word  0x000000FF
keep:            .word  0xFFFFFF00
underscore:      .word  0x5F5F5F00
n:               .word  0xA
rLen:            .word  0x0
lLen:            .word  0x1
letter:          .word  0x0
letter2:         .word  0x0
bufsize:		 .word  0x20

    .text
_start:
    .org         0x90
    load_imm     0x0
    store_addr   len
_cycle:
    load_addr    len                         ; загружем длину
    add          one                         ; +1
    store_addr   len                         ; сохраняем
    load_addr    0x80                        ; берём букву
    store_addr   letter						 ; сохраняем в переменную
    sub          n                           ;вычитаем 10, чтобы проверить если это конец строки
    beqz         _main                       ;это конец строки - выйти из цикла
	load_addr len
	sub bufsize								 ;если символ не равен 10 и это конец буфера - это ошибка
	beqz         _error
    load_addr    letter
    or           underscore
    store_ind    len                         ; записываем букву
    jmp          _cycle                      ; повторяем цикл если ещё есть длина
_main:
    load_imm     0x5F5F5F5F
    store_ind    len                         ; затираем \n которое мы только то записали
    load_addr    len
    sub          one                         ; загружаем адре и отнимаем 1 (т.к \n не считаеся)
    store_addr   len						 ; сохраняем длину слова

    load_addr    0x0						 ; берём начало слова
    and          keep						 ; удаляем первый разряд
    store_addr   letter						 ; сохраняем
    load_addr    len
    or           letter						 ; добавляем длину вместо первого разряда
    store_addr   0x0						 ; записываем
	
    load_addr    len
    store_addr   rLen                        ; задаём начальный индекс слева

_reverse:
    beqz         _output					 ; выходим если правый индекс 0 или индексы спава и лева дошли друг до друга
    bltz          _output
    load_addr    lLen
    load_acc                                 ; берём букву слева
    and          cut                         ; оставляем только её
    store_addr   letter                      ; сохраняем

    load_addr    rLen
    load_acc                                 ; берём букву справа
    and          cut                         ; оставляем только её
    store_addr   letter2                     ;сохраняем

    load_addr    lLen
    load_acc                                 ; берём промежуток слева
    and          keep                        ; удаляем одну букву
    or           letter2                     ; заменяем на новую
    store_ind    lLen                        ; сохраняем

    load_addr    rLen
    load_acc                                 ; берём промежуток справа
    and          keep                        ; удаляем одну букву
    or           letter                      ; ставим букву слева
    store_ind    rLen                        ;сохраняем

    load_addr    lLen				
    add          one
    store_addr   lLen
											 ; тут мы обновляем индексы
    load_addr    rLen
    sub          one
    store_addr   rLen

    sub          lLen
    jmp          _reverse

_output:
    load_imm     0x1
    store_addr   lLen
_outCycle:
	sub          len						; проверяем что индекс меньше len
    bgtz          _end						; иначе выходим
    load_addr    lLen						; загружаем промежуток
    load_acc
    and          cut						; выделяем из него букву
    store_addr   0x84						; записываем ответ
    load_addr    lLen
    add          one						; обновляем индекс
    store_addr   lLen
    jmp          _outCycle
_end:
    halt
	
_error:
	load_imm 0xCCCCCCCC
	store_addr 0x84
	halt
	
	
