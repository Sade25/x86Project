.file "lab4.s"

# Name: Sade Ahmed

# BY SUBMITTING THIS FILE TO CARMEN, I CERTIFY THAT I HAVE STRICTLY
# ADHERED TO THE TENURES OF THE OHIO STATE UNIVERSITY'S ACADEMIC
# INTEGRITY POLICY WITH RESPECT TO THIS ASSIGNMENT, INCLUDING, BUT
# NOT LIMITED TO, ALL COURSE RULES. I CERTIFY THAT I HAVE WRITTEN
# THE CODE FOR THIS LAB MYSELF, AND WITHOUT ASSISTANCE OF ANY KIND
# FROM ANYONE ELSE (EXCEPT PERHAPS THE COURSE INSTRUCTOR OR GRADERS
# FOR THE COURSE).
	
	
.section .rodata
LC0: .string "\nProducts\n"
LC1: .string "%i\n"
LC2: .string "Sums\n"
LC3: .string "%hi\n"
LC4: .string "Elements in intArray1\n"
LC5: .string "%i\n"
LC6: .string "\n"
LC7: .string "The maximum value in intArray2 is: %i\n\n"

.data
.align 8
sizeIntArrays:
	.long 5
sizeShortArrays:
	.word 4
intArray1:
	.long 10
	.long 25
	.long 33
	.long 48
	.long 52
intArray2:
	.long 20
	.long -37
	.long 42
	.long -61
	.long -10
shortArray1:
	.word 69
	.word 95
	.word 107
	.word 332
shortArray2:
	.word -87
	.word 331
	.word -49
	.word -88

#The main function

.globl main
.type	main, @function
.text

main:

pushq %rbp			#stack set up
movq %rsp, %rbp

				#pass parameters to multInts
movq $intArray1, %rdi		#mov 8 byte pointer to register for first parameter
movq $intArray2, %rsi		#mov 8 byte pointer to register for second parameter
movl sizeIntArrays, %edx	#mov 4 byte size to register for third parameter	

				#call multInts
call multInts


movq $shortArray1,%rdi		#pass parameters to addShorts
movq $shortArray2,%rsi
movw sizeShortArrays, %dx	

call addShorts			#call addShorts

				#pass parameters to printArray for 1st call

movq $intArray1,%rdi
movl sizeIntArrays, %esi	
call printArray			#call printArray 1st time

	
				#pass parameters to invertArray

movq $intArray1,%rdi
movl sizeIntArrays, %esi

call invertArray		#call invertArray

	
movq $intArray1,%rdi		#pass parameters to printArray for 2nd call
movl sizeIntArrays, %esi	
call printArray
				#call printArray 2nd time to print inverted intArray1

	
				#pass parameters to findAndReturnMax
	

movq $intArray2,%rdi
movl sizeIntArrays, %esi
call findAndReturnMax		#call findAndReturnMax

pushq %rdi
pushq %rsi
pushq %rdx	
				#pass parameters to printf to print value returned by findAndReturnMax
movq $LC7,%rdi
movq %rax,%rsi
movq $0,%rax
	
call printf

				#call printf to print value returned by findAndReturnMax

	
movl $0, %eax			#set return register to 0

movq %rbp, %rsp			#do stack restoration
popq %rbp
	
ret
	
.size main, .-main

# This function will mulitply and print two arrays that are the same size
.globl multInts
.type	multInts, @function
multInts:

pushq %rbp			#stack set up
movq %rsp, %rbp

				#code to pass parameters to printf to print label for output
	
pushq %rdi			#preserve parameter (in caller save register)
				#on stack
pushq %rsi			#preserve parameter on stack
pushq %rdx			#preserve parameter on stack

movq $LC0, %rdi			#pass pointer to read-only "Products\n" string
movq $0, %rax			#set rax for number of float arguments
				#call printf to print label
call printf

popq %rdx			#restore parameter from stack
popq %rsi			#restore parameter from stack
popq %rdi			#restore parameter from stack
			
movq $0, %r8			#initialize index in caller save register
movq $0,%rcx

loop:
cmpl %r8d,%edx

je exit
				#loop code to put array element for intArray 1 in register and
movl (%rdi,%r8,4),%ecx 		#multiply by correct element in intArray2
imull (%rsi,%r8,4),%ecx

pushq %rdi
pushq %rcx			#preserve parameter (in caller save register)
pushq %r8			#on stack
pushq %rsi			#preserve parameter on stack
pushq %rdx			#preserve parameter on stack

movq $LC1, %rdi
movl %ecx,%esi			#pass pointer to read-only "Products\n" string
movq $0, %rax			#set rax for number of float arguments
				#call printf to print label
call printf


popq %rdx			#restore parameter from stack
popq %rsi
popq %r8
popq %rcx			#restore parameter from stack
popq %rdi

incq %r8			#code to pass parameters to printf to print out product

jmp loop	
				#jump back to top of loop

exit:
	movq $LC6, %rdi		#pass address of read-only string as first parameter
				#to printf to print blank line
	movq $0, %rax		#set parameter for number of float arguments

	call printf

	movq %rbp, %rsp		#stack restoration
	popq %rbp
	
	ret
.size multInts, .-multInts

# This function will add and print the values of two arrays but first flipping the second array
.globl addShorts
.type	addShorts, @function
addShorts:

pushq %rbp				#stack set up
movq %rsp, %rbp

					#code to pass parameters to printf to print output label
pushq %rdi
pushq %rsi
pushq %rdx

movq $LC2,%rdi
movq $0, %rax

call printf

popq %rdx
popq %rsi
popq %rdi				#code to initialize any variables needed for loop
					#to calculate and print sums
movq $0, %rax
movq $0, %rcx
movw %dx,%cx
decq %rcx

loop1:
	movq $0, %r10
	cmpw %dx, %ax			#compare shortArray1 index to size
	je exit1			#exit if equal

	movw (%rdi,%rax,2), %r10w	#move shortArray1 op into word register
	addw (%rsi,%rcx,2), %r10w	#add shortArray2 op

	pushq %rdx			#push caller save reg
	pushq %rax	 		#push caller save reg
	pushq %rcx	 		#push caller save reg
	pushq %rdi	 		#push caller save reg
	pushq %rsi	 		#push caller save reg

movq $LC3, %rdi				#pass parameters to printf to print sum
movq %r10,%rsi
movq $0, %rax	
					#preserve any values in caller save registers
call printf				#before call to printf

popq %rsi
popq %rdi
popq %rcx
popq %rax
popq %rdx
					#call printf

decq %rcx
incq %rax
					#restore values to caller save registers

	
	jmp loop1

exit1:
	movq $LC6, %rdi			#push address of read-only string to print blank line
	movq $0, %rax			#set parameter rax for number of float arguments
	call printf

	movq %rbp, %rsp			#stack restoration
	popq %rbp
	
	ret
.size addShorts, .-addShorts

# This function will invert/reverse an array
.globl invertArray
.type	invertArray, @function
invertArray:

pushq %rbp			#stack set up
movq %rsp, %rbp

movq $0,%rax
movq $0,%rdx			#clear registers and initialize two indexes


movl %esi,%edx
decq %rdx			#in 64 bit registers


				#loop code after loop2 label below to swap value from second
				#half of array with value from first  half of array
				#and to terminate when all values swapped
loop2:
cmpq %rax,%rdx

jl exit2			#cmp instruction
				#conditional jump to jump out if exit condition met
movl (%rdi,%rax,4),%r10d
movl (%rdi,%rdx,4),%r11d
movl %r10d, (%rdi, %rdx, 4)
movl %r11d, (%rdi, %rax, 4)

incq %rax
decq %rdx

	
	
	jmp loop2		#jump back to top of loop

exit2:
	movq %rbp, %rsp		#stack restoration
	popq %rbp
	
	ret
.size invertArray, .-invertArray

# This function will print the Array
.globl printArray
.type	printArray, @function
printArray:
	
pushq %rbp			#stack set up
movq %rsp, %rbp


#code to pass parmaters to printf to print output label

pushq %rdi			#push any caller save registers
pushq %rsi
pushq %rdx


movq $LC4,%rdi			#pass parameters to printf
movq $0,%rax

call printf			#call printf to print output label

popq %rdx
popq %rsi			#pop caller save registers
popq %rdi			

movq $0,%r8
movq $0,%rbx
movq $0,%rax			#initialize index register to access array elements

loop3:		
				#loop to pass parameters to printf to print array element
cmpl %r8d,%esi			#cmp instruction to test index value

je exit3			#conditional jump to exit if condition met

movq $0, %rcx
movl (%rdi,%r8,4),%r10d

	
pushq %rdi
pushq %rsi
pushq %r8
pushq %rdx
pushq %rax			#push caller save registers

				#pass parameters to printf to print element
	
				#move address of read-only string
movq $LC5,%rdi
movq $0, %rdx
movl %ecx,%edx
movq %r10, %rsi
movq $0, %rax			#set parameter for number of float arguments
	
call printf


				#pop caller save registers
popq %rax
popq %rdx
popq %r8
popq %rsi
popq %rdi

incq %r8			#inc index to get next element on next iteration

jmp loop3			#jump back to top

exit3:
	movq $LC6, %rdi		#address of read only string to rdi as 1st param
				#to printf to print blank line
	movq $0, %rax		#set number of float arguments
	call printf

	popq %rbx		#restore callee save register

	movq %rbp, %rsp		#stack restoration
	popq %rbp
	
	ret
.size printArray, .-printArray

# This function will find the max value of the array
# BE SURE TO ADD ASSEMBLER DIRECTIVES FOR THE LAST FUNCTION!!!!!
# SEE THE DIRECTIVES FOR THE FUNCTIONS ABOVE TO HELP YOU
	
findAndReturnMax:

pushq %rbp			#stack set up
movq %rsp, %rbp


movq $0,%r8
movq $0,%rax
movq $0,%r9			#initialize array index in 64 bit register
				#initialize max to first element of array
movl (%rdi,%r8,4),%eax		#Be sure to use return register for max value

loop4:				#loop code to compare next array element to current max
	
cmpl %r8d,%esi
je exit4			#cmp instruction to check index

movl (%rdi,%r8,4),%r9d
cmpl %r9d,%eax
				#jump to exit if condition met
cmovl (%rdi,%r8,4),%eax	
				#code to cmp next element to current max
incq %r8			#increment index
	jmp loop4		#jump back to top of loop

exit4:	
	movq %rbp, %rsp		#stack restoration
	popq %rbp
	
	ret
.size findAndReturnMax, .-findAndReturnMax

#BE SURE TO ADD .size ASSEMBLER DIRECTIVE FOR findAndReturnMax
	
