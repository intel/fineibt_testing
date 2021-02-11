.text
.globl test_cet_bits
test_cet_bits:
nopl   0x200(%rax,%rax,1)
nopl   0x200(%rax,%rax,1)
nopl   0x200(%rax,%rax,1)
nopl   0x200(%rax,%rax,1)
nopl   0x200(%rax,%rax,1)
nopl   0x200(%rax,%rax,1)
push %rbp
mov %rsp, %rbp
mov %fs:0x48,%rax
testb $0x1,%fs:0x48
je 1f
call cet_set_1
jmp 2f
1:
call cet_not_set_1
2:
testb $0x2,%fs:0x48
je 1f
call cet_set_2
jmp 2f
1:
call cet_not_set_2
2:
testb $0x4,%fs:0x48
je 1f
call cet_set_4
jmp 2f
1:
call cet_not_set_4
2:
testb $0x8,%fs:0x48
je 1f
call cet_set_8
jmp 2f
1:
call cet_not_set_8
2:
testb $0x10,%fs:0x48
je 1f
call cet_set_10
jmp 2f
1:
call cet_not_set_10
2:
pop %rbp
ret
