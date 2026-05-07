    .data
input_addr:      .word  0x80
output_addr:     .word  0x84
    .text
_start:
    @p input_addr a! @       \ считываем входное значение: n
    dup
    if setError              \ тут мы проверяем на то что число положительное
    dup
    -if noError
    setError ;
noError:
    makeEven                 \процедура возвращающая чётное число, которое <= n
    dup
    2/                       \делим на 2 (получаем k для формулы (n+2)*k/2)
    dup
    lit -46340               \проверяем, что k в области определения
    +
    -if setError2            \возвращаем CCCC при переполнении
    over                     \ помещаем n на вершину стека
    lit 2 +                  \прибавляем к нему 2 \[even+2,k]
    2/                       \делим на 2. это перед умножением на k т.к иначе число получается отрицательным, и деление на 2 будет работать некорректно
    a!                       \ помещаем в a для умножения на k
    lit 0                    \[0,k]
    multiply
exit:
    @p output_addr a! !
    halt
setError:
    lit -1
    exit ;
setError2:
    lit 0xCCCCCCCC
    exit ;
makeEven:
    lit 0xfffffffe
    and                      \ обнуляем последний бит, чтобы взять ближайшее чётное
    ;
multiply:
    lit 31 >r                \ for R = 31
multiply_do:
    +*
    next multiply_do
    drop drop a
    ;



