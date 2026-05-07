 .data
input_addr:      .word  0x80     
output_addr:     .word  0x84
.text
.org 0x88
_start:
	; t0 - temp	
	; t1 - входное значение
	addi 	t2, zero ,0x1					 ; загрузим маску	
	; t3 - результат		
	addi 	t4,	zero, 0x20					 ; счётчик кол-ва бит
	
	addi 	sp, zero ,0x7F				     ; инициализируем стек
	
_main:
    lui      t0, %hi(input_addr)             ; загрузили верх от метки
    addi     t0, t0, %lo(input_addr)         ; сложили с низом от метки
    lw       t0, 0(t0)                       ; загрузили 0x80 с метки
    lw       t1, 0(t0)                       ; загрузили входное значение из 0x80
	
	jal ra, _reverse						 ; идём разворачивать
	
	lui      t0, %hi(output_addr)             ; загрузили верх от метки
    addi     t0, t0, %lo(output_addr)         ; сложили с низом от метки
	lw       t0, 0(t0)						  ; получили адрес вывода
	sw	t3, 0(t0)					 		  ; записываем ответ
	halt
	
_reverse:
	addi sp, sp, -4							; сдвигаем стек
	sw ra, 0(sp)							; запишем адрес возврата
	
	_cycle:
		jal ra, _exctract					; добавляем символ в ответ
		addi t4, t4, -1						; уменьшаем счётчик
		beqz t4, _cycle_exit				; если счётчик 0, выходим
		srli t1, t1, 1						; сдвигаем число вправо
		slli t3, t3, 1						; сдвигаем ответ влево
	j _cycle
	_cycle_exit:
	lw ra, 0(sp)							; восстанавливаем адрес возврата
	jr ra									; возвращаемся

_exctract:
	and t0, t1, t2							; взяли 1 символ
	or 	t3,	t3, t0							; добавили в ответ
	jr ra
	
	
	
	
	


 
	