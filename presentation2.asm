
	.text

	.globl	main
main:
	#s0 array
    #s1 arraySize
    #t0 i
    #initialize values
    la $s0, array #puts array {2,3,5,7,11} into $s0
    li $s1, 5 #puts arraySize, which is 5 into $s1
    li $s2, 0 #loads 0 into $t0

forLoop:
    #Loop check
    bge $s2, $s1, endLoop #if i >= arraySize jump to endLoop

    #prints "Array[
    li $v0, 4 #set $v0 to 4 to print string
    la $a0, msg1 #loads "Array["
    syscall

    #prints i
    li $v0, 1 #set $v0 to 1 to print integer
    move $a0, $s2 #copy i into $a0
    syscall

   #prints "]="
    li $v0, 4 #set $v0 to 4 to print string
    la $a0, msg2 #loads "Array["
    syscall 

    #prints array[i]
    li $t0, 4           # t0 = 4
    mul $t0, $t0, $s2   # t0 = i * 4
    add $t0, $t0, $s0   # t0 = &array[i]
    lw $t0, 0($t0)      # t0 = array[i]

    li $v0, 1 #set $v0 to 1 to print integer
    move $a0, $t0 #copy $t0 or array[i] into $a0
    syscall

    #prints "\n"
    li $v0, 4 #set $v0 to 4 to print string
    la $a0, msg3 #loads "Array["
    syscall 

    addi $s2, $s2, 1 #i++

    j forLoop
endLoop:

    #prints "Sum of array is "
    li $v0, 4 #set $v0 to 4 to print string
    la $a0, msg4 #loads "Array["
    syscall 

    #get arraySum
    move $a0, $s0 #set array as 1st argument
    move $a1, $s1 #set arraySize as 2nd argument
    jal arraySum #call arraySum

    move $a0, $v0 #load return value from arraySum
    li $v0, 1 #set $v0 to 1 to print integer
    syscall

    #prints "\n"
    li $v0, 4 #set $v0 to 4 to print string
    la $a0, msg3 #loads "Array["
    syscall 

    # Exit
	li	$v0,10		# exit
	syscall

arraySum:

    addi $sp, $sp, 4 #adjust stack pointer
    sw $s0, 0($sp) #save $s0
    addi $sp, $sp, 4 #adjust stack pointer
    sw $ra, 0($sp) #save $ra

    li $s0, 0 #$s0 acts as result
    bne $a1, 0, else #if size != 0 jump to else
    j if
if:
    li $s0, 0 #result = 0
    j endif
else:
    addi $sp, $sp, 4 #adjust stack pointer
    sw $a0, 0($sp) #save array

    addi $a0, $a0, 4 #$a0 = &array[1]
    addi $a1, $a1, -1 #$a1 = arraySize - 1

    jal arraySum
    #pop from stack
    lw $a0, 0($sp) #load $a0
    addi $sp, $sp, -4 #adjust stack pointer

    lw $t0, 0($a0) #$t0 = *array

    add $s0, $t0, $v0 #result = *array + arraySum(&array[1], arraySize-1);
    j endif
endif:

    move $v0, $s0 #put result in return value

    #pop from stack
    lw $ra, 0($sp) #restore $ra
    addi $sp, $sp, -4 #adjust stack pointer
    lw $s0, 0($sp) #restore $s0
    addi $sp, $sp, -4 #adjust stack pointer

    jr $ra



	# Start .data segment (data!)
	.data
array: .word 2, 3, 5, 7, 11
msg1: .asciiz "Array["
msg2: .asciiz "]="
msg3: .asciiz "\n"
msg4: .asciiz "Sum of array is "