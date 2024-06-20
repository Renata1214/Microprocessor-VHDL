# Microprocessor-VHDL

TASK 1: Implement the microprocessor in VHDL.
Instructions and deliverables:

##Part 1) 
Implement the missing parts in the functional modules. Make sure to use the opcode
type from “common.vhd” in your coding.

Test your implementation by running the provided testbench as is – related deliverables
are described in Task 2.

##Part 2)
Report how many clock cycles your implementation requires to fully execute one
instruction, from loading the instruction to decoding it, to computing the result, and to
writing back the result. Look into behavioral simulation runs to answer that question.

##Part 3)
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
