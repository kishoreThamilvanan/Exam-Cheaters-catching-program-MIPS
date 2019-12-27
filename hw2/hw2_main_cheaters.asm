.data
newline: .asciiz "\n"
comma: .asciiz ","

cheaters: .space 100

.include "cheaters.asm" #include the sample 2D arrays


.text
.globl main

main:


    # Test for find_cheaters
    # modify the arguments to change tests

    la $a0, room2
    li $a1, 5  
    li $a2, 6
    la $a3, cheaters
    jal find_cheaters

    move $a0, $v0
    li $v0, 1
    syscall

    la $a0, comma
    li $v0, 4
    syscall

    move $a0, $v1
    li $v0, 1
    syscall

    la $a0, newline
    li $v0, 4
    syscall

    # Exit program

    li $v0, 10
    syscall




.include "hw2.asm"
.include "gradeshelpers.asm"

