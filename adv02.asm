        global  _start

        section .text
_start:
        xor     rdx, rdx        ; rdx = count (upper 32 bits: dampened count - count)
        lea     rsi, data
        mov     rcx, reports
.loop:
        cmp     rcx, 0
        je      end
        push    rdx
        call    check
        pop     rax
        cmp     rax, rdx
        jne     .safe           ; only try to dampen if it was not safe
        call    dampen
.safe:
        call    next
        dec     rcx
        jmp     .loop

end:
        xor     rax, rax
        mov     eax, edx
        push    rax
        push    rdx
        call    println
        pop     rdx
        pop     rax
hm:     shr     rdx, 32
        add     rax, rdx
        call    println

        xor     rdi, rdi
        mov     rax, 60         ; exit (rdi = status)
        syscall

;;; Checks reports starting in [rsi] and increases rdx if safe
;;; Leaves [rsi] at the start of the report
check:
        call    monotone
        mov     rbx, rax
        call    smalldiff
        and     rax, rbx
        jz      .unsafe
.safe:
        inc     rdx
.unsafe:
        ret

;;; Same as check, but tries to leave out one number,
;;; and increases the upper half of rdx
dampen:
        mov     rbp, 0          ; index of the number to leave out
.loop:
        cmp     byte [rsi+rbp], -1
        je      .unsafe
        call    copy
        push    rdx
        push    rsi
        lea     rsi, buffer
        call    check
        pop     rsi
        mov     rax, rdx
        pop     rdx
        cmp     rax, rdx
        jne     .safe
        inc     rbp
        jmp     .loop
.safe:
        mov     rax, 1
        shl     rax, 32
        add     rdx, rax
.unsafe:
        ret

;;; Copies from [rsi] until (and including) -1 to [buf], leaving out [rsi+bp]
copy:
        lea     rbx, buffer
        mov     rdi, 0
.loop:
        cmp     rdi, rbp
        je      .found
        mov     al, [rsi+rdi]
        mov     [rbx+rdi], al
        cmp     al, -1
        jne     .next
        ret
.found:
        dec     rbx
.next:
        inc     rdi
        jmp     .loop

%macro  checkmonotone 1
        mov     rdi, rsi
        mov     al, [rdi]
        inc     rdi
%%loop:
        cmp     byte [rdi], -1
        je      %%safe
        mov     ah, [rdi]
        cmp     al, ah
        %1      %%unsafe
        mov     al, ah
        inc     rdi
        jmp     %%loop
%%safe:
        mov     rax, 1
        jmp     %%end
%%unsafe:
        xor     rax, rax
%%end:
%endmacro

monotone:
        mov     rdi, rsi
        mov     al, [rdi]
        inc     rdi
        mov     ah, [rdi]
        cmp     al, ah
        jl      increasing
        checkmonotone jle
        ret
increasing:
        checkmonotone jge
        ret

smalldiff:
        mov     rdi, rsi
        mov     al, [rdi]
        inc     rdi
.loop:
        mov     ah, [rdi]
        cmp     ah, -1
        je      .safe
        sub     al, ah
        jz      .unsafe
        cmp     al, -3
        jl      .unsafe
        cmp     al, 3
        jg      .unsafe
        mov     al, ah
        inc     rdi
        jmp     .loop
.safe:
        mov     rax, 1
        ret
.unsafe:
        xor     rax, rax
        ret

next:
        cmp     byte [rsi], -1
        je      .found
        inc     rsi
        jmp     next
.found:
        inc     rsi
        ret

;;; Prints a nonnegative integer (rax = number)
print:
        cmp     rax, 10
        jge     .large
        mov     rdi, 1
        add     al, 48
        mov     [digit], al
        lea     rsi, digit
        mov     rdx, 1
        mov     rax, 1
        syscall                 ; write (rdi = fd, rsi = buf, rdx = count)
        ret
.large:
        xor     rdx, rdx
        mov     rbx, 10
        div     rbx
        push    rdx
        call    print
        pop     rax
        call    print
        ret

;;; Prints a nonnegative integer and a newline (rax = number)
println:
        call    print
        mov     rdi, 1
        lea     rsi, nl
        mov     rdx, 1
        mov     rax, 1
        syscall                 ; write (rdi = fd, rsi = buf, rdx = count)
        ret

        section .bss
digit:  db      ?
buffer: resb    100             ; maximum number of levels in a report (including the final -1)

        section .data
nl:     db      10
data:
