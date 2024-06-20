# Microprocessor-VHDL

TASK 1: Implement the microprocessor in VHDL.
Instructions and deliverables:

## Part 1) 
Implement the missing parts in the functional modules. Make sure to use the opcode
type from “common.vhd” in your coding.

Test your implementation by running the provided testbench as is – related deliverables
are described in Task 2.

## Part 2)
Report how many clock cycles your implementation requires to fully execute one
instruction, from loading the instruction to decoding it, to computing the result, and to
writing back the result. Look into behavioral simulation runs to answer that question.

## Part 3)
Implement the missing parts in the FPGA top-level module. This will be similar to
the basic top-level module, but you also have to instantiate and wire up the display control
unit for that.

Make sure to provide the clock signal “clk” only for the display controller, whereas the
pseudo clock signal “clk_proc” is to be used for the processor and its modules and is
mapped to an FPGA button. Use the related, already provided UCF.

You should tackle this part only once you have done some behavioral simulations on the
basic top-level module, as this helps you to identify any issues with the working of your
processor in general, without bothering about any possible issues with the FPGA
implementation yet.

Once implemented, also provide the floorplan snapshot/PDF via the following ISE steps:
“Implement Design”, “Place & Route”, “Analyze Timing / Floorplan Design (PlanAhead).”
Make sure that the logic components are visible.

## TASK 2
Test your processor by executing the following simple program:
ADDI R1, R0, -32 // R1 = R0 + -32 = -32
ADDI R2, R0, -32 // R2 = R0 + -32 = -32
ADD R3, R1, R2 // R3 = R1 + R2 = -64
ADD R3, R3, R3 // R3 = R3 + R3 = -128
ADD R3, R3, R3 // R3 = R3 + R3 = -256
ADD R3, R3, R3 // R3 = R3 + R3 = -512
ADD R3, R3, R3 // R3 = R3 + R3 = -1024
ADD R3, R3, R3 // R3 = R3 + R3 = -2048
ADD R3, R3, R3 // R3 = R3 + R3 = -4096
ADD R3, R3, R3 // R3 = R3 + R3 = -8192
SUBI R4, R3, -1 // R4 = R3 - 1 = 8191; overflow, should be -8193
Note that the binary code for the instruction sequence above is already pre-loaded as binary
code in the instruction ROM.

## TASK 3
Evaluate the following binary program using your processor:
1001 001 000 000 101
1001 010 000 000 000
1001 010 010 000 101
1011 001 001 000 001
1100 111 000 001 110

## TASK 4
Write your own program for the microprocessor.
Instructions and deliverables:

1) Describe, in keywords, a program that can be run on the processor – get as creative as
you can. You must use at least one jump or one branch instruction, two arithmetic
and/or logical operations, and it must be at least 5 lines long.
Make sure that your program implementation is flexible. That is, a hard-coded run of
some simple algorithm, like always counting from 0 to 5, is not allowed. Rather, your
program must work for different inputs, which are to be loaded into registers in the
beginning of the program (these load operations do not count for the 5-lines target.)
Accordingly, you want to have three parts in your program: 1) initialization of input(s)
into register(s), 2) actual computation – the actual algorithm, and 3) storing of the final
result(s) in register(s).
Besides the general description, provide also the binary code.

3) Discuss and provide, in keywords, the expected behaviour of the program for meaningful
inputs of your choice. You may run behavioral simulations to do so, but make sure that
all related values and registers are clearly visible.

## Answer to Last Task

## PART 1: Program description
We wrote several different programs to test our code. The most meaningful one calculates the perimeter of two rectangles to test if they are equal. It takes as immediate value the length of the two sides of the two rectangles. It multiplies each side length by 2 using shift left logical function. Finally, it adds the resulting products to give the total perimeter of the rectangle. This is done separately for both rectangles. Then the final perimeters are compared, if they are equal, the program returns the perimeter then ends. Otherwise the program subtracts the two returning the difference between their parameters.

Binary code:
--Program to compare the perimeters of 2 rectangles.
		
	rom(0) <= opcode_type_to_std_logic_vector(OP_ADDI) & b"001" & b"000" & b"000_010"; -- R1: R0 + 2 = 2
	rom(1) <= opcode_type_to_std_logic_vector(OP_ADDI) & b"010" & b"000" & b"000_011"; -- R2: R0 + 3 = 3
		
	rom(2) <= opcode_type_to_std_logic_vector(OP_ADDI) & b"011" & b"000" & b"000_010"; -- R3: R0 + 2 = 2
	rom(3) <= opcode_type_to_std_logic_vector(OP_ADDI) & b"100" & b"000" & b"000_010"; -- R4: R0 + 3 = 3
		
	rom(4) <= opcode_type_to_std_logic_vector(OP_SLL) & b"101" & b"001" & b"000_001"; -- R5: 2R1 = 4
	rom(5) <= opcode_type_to_std_logic_vector(OP_SLL) & b"110" & b"010" & b"000_001"; -- R6: 2R2 = 6
	rom(6) <= opcode_type_to_std_logic_vector(OP_ADD) & b"111" & b"101" & b"110_000"; --R7: R5+R6 = 10
	
	rom(7) <= opcode_type_to_std_logic_vector(OP_SLL) & b"011" & b"011" & b"000_001"; -- R3: 2R3 = 4
	rom(8) <= opcode_type_to_std_logic_vector(OP_SLL) & b"100" & b"100" & b"000_001"; -- R4: 4R4 = 6
	rom(9) <= opcode_type_to_std_logic_vector(OP_ADD) & b"001" & b"011" & b"100_000"; --R1: R3+R4 = 10
	
	rom(10) <= opcode_type_to_std_logic_vector(OP_BE) & b"000" & b"111" & b"001_010"; -- if R1=R7 PC=PC +2 else PC=PC+1 RD AND TAIL
	rom(11) <= opcode_type_to_std_logic_vector(OP_SUB) & b"011" & b"111" & b"001_000"; --R3= R7-R1 whose abs value is diffrernce
	rom(12) <= opcode_type_to_std_logic_vector(OP_AND) & b"011" & b"111" & b"001_000"; --if equal just returns parameter else returns random number
	
	--	rom(5) <= opcode_type_to_std_logic_vector(OP_ADD) & b"101" & b"011" & b"100_100"; --R5: R3+R4 = ....
	--	rom(6) <= opcode_type_to_std_logic_vector(OP_SUBI) & b"110" & b"101" & b"010_000"; --R6: R5 - 16
	--	rom(7) <= opcode_type_to_std_logic_vector(OP_SLL) & b"011" & b"001" & b"000_001"; -- R3: 2R1 = 4
	--	rom(8) <= opcode_type_to_std_logic_vector(OP_ADDI) & b"010" & b"000" & b"000_010"; -- R2: R0 + 2 = 2


## PART 2: Expected behavior
For example, for immediate values 2 and 3 initialized to registers R1 And R2 respectively, the program would first multiply the 2 by 2, storing 4 in register 5 (R5). Then it would multiply 3 by 2 storing 6 into the register 6 (R6). Finally, it sums R5 and R6 into R7 storing the perimeter which is 10. Considering the second rectangle, for immediate values 2 and 3 initialized to registers R3 And R4 respectively, the program would first multiply the 2 by 2, storing 4 in register 3 (R3). Then it would multiply 3 by 2 storing 6 into the register 4 (R4). Finally, it sums R3 and R4 into R1 storing the perimeter which is 10.
Finally, using BE where RD will be 000 Rs1 111 Rs2 001 and the tail 010, the values saved at register 7 and register 1 are compared. In this case IV will be equal to 00000000000010. Hence, if the compared registers are equal, the new PC will be equal to PC+IV which  should be 12. If the registers are not equal PC should equal PC+1 which in this case should be 11. 

If PC equals 11 the value of the difference between R7 and R1 will be stored into register 3. In this case this operation will not take place. 
If PC equals 12 (as it will according to the length of the sizes of the rectangles), the registers 3 and 7 will be and such that the parameter is returned, hence in this case it would return 10 and save into register 3. 

