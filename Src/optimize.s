/*
 * optimize.s
 *
 *  Created on: 20/8/2024
 *      Author: Ni Qingqing & Hou Linxin
 */
   .syntax unified
  .cpu cortex-m4
  .fpu softvfp
  .thumb @instructions are 16-bits wide, have to use pc-relative addressing

    .global optimize

@ Start of executable code
.section .text

@ EE2028 Assignment 1, Sem 1, AY 2024/25
@ (c) ECE NUS, 2024

@ Write Student 1’s Name here: Charlyn Kwan Ting Yu
@ Write Student 2’s Name here: Leow Kai Jie

@ Look-up table for registers:

@ R0: address of a, address of b in [R0,#4]
@ R1: x0 / x
@ R2: lambda
@ R3: a -> 2a
@ R4: b -> 10b
@ R5: number of rounds
@ R6: xprev
@ R7: BLOCK
@ R8: temp values
@ R9: gradient
@ R11: BLOCK

@ write your program from here:


@input: (abc=[30,40,-30], x0=-67, lambda=1)
optimize:

   PUSH {R14} // adding LR(return memory) addr to main.c to stack
   BL SUBROUTINE
   POP {R14}
  @ returns int *xsol: [ solution , no. of rounds ]
   BX LR @ go back to c prog

SUBROUTINE:

 	@ Load a and b values into registers
	LDR R3, [R0], #4 // LDR a into R3
	LSL R3, #1 // a -> 2a into R3

	LDR R4, [R0] // LDR b into R4
	MOV R11, #10
	MUL R4, R11 // b -> 10b into R4

	MOV R5, #0 // initialise number of rounds

	@ While loop (if x == xprev)
	B loop


loop:
	@ Step 1: Calculate value of gradient
	MLA R9, R3, R1, R4// Store gradient in R9, fp=2*a*x + (b * 10)
	@ Step 2: Move x to xprev
	MOV R6, R1
	@ Step 3: Calculate change
	MUL R9, R2 // lamda * fp
	MOV R8, #100
	SDIV R9, R8 // lambda * fp / 100
	@ Step 4: Update x value
	SUB R1, R9
	@ Step 5: Update number of rounds
	ADD R5, #1
	@ Step 6: Set exit loop condition
	CMP R1, R6 // compare x and xprev
	BEQ end_loop
	BNE loop

end_loop:
	@ Store answer and no. of rounds into ANS memory addr
	LDR R0, =ANS
	STR R1, [R0]
	STR R5, [R0, #4]
	BX LR

@ Constants
.lcomm ANS 8
