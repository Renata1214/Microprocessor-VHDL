library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

use work.common.all;

entity top_processor_FPGA is
	port ( 	next_instr : in STD_LOGIC;
		clk : in STD_LOGIC;
		rst : in STD_LOGIC;

		-- for display
		seg_bits : out  STD_LOGIC_VECTOR (0 to 7);			  
		seg_an : out  STD_LOGIC_VECTOR (3 downto 0)
	);
end top_processor_FPGA;

architecture Behavioral of top_processor_FPGA is

component Display_Controller
	port ( 	clk : in STD_LOGIC;
		rst : in STD_LOGIC;

		opcode : in opcode_type;

	 	operand_1 : in STD_LOGIC_VECTOR (13 downto 0);
	 	operand_2 : in STD_LOGIC_VECTOR (13 downto 0);

	 	result : in STD_LOGIC_VECTOR (13 downto 0);
		overflow : in STD_LOGIC;

		seg_bits : out  STD_LOGIC_VECTOR (0 to 7);			  
		seg_an : out  STD_LOGIC_VECTOR (3 downto 0)
	     );
end component;

component Controller
	port ( 	opcode : in opcode_type;

	 	operand_1 : out STD_LOGIC_VECTOR (13 downto 0);
	 	operand_2 : out STD_LOGIC_VECTOR (13 downto 0);

	 	result : in STD_LOGIC_VECTOR (13 downto 0);

		curr_PC : in STD_LOGIC_VECTOR (6 downto 0);

		new_PC : out STD_LOGIC_VECTOR (6 downto 0);
		PC_we : out STD_LOGIC;
		PC_incr : out STD_LOGIC;

		Rs1_data : in STD_LOGIC_VECTOR (13 downto 0);
		Rs2_data : in STD_LOGIC_VECTOR (13 downto 0);
		immediate : in STD_LOGIC_VECTOR (13 downto 0);

		Rd_we : out STD_LOGIC;
		Rd_data : out STD_LOGIC_VECTOR (13 downto 0)
	     );
end component;

-- TODO add other components
component Instructions_ROM
	port ( 	address_in : in STD_LOGIC_VECTOR (6 downto 0);
		data_out : out STD_LOGIC_VECTOR (15 downto 0)
	     );
end component;

component PC
	port ( 	clk : in STD_LOGIC;
		rst: in STD_LOGIC;

		PC_in : in STD_LOGIC_VECTOR (6 downto 0);
		PC_out : out STD_LOGIC_VECTOR (6 downto 0);

		PC_we : in STD_LOGIC;
		PC_incr : in STD_LOGIC
	     );
end component;

component Registers
	port ( 	clk : in STD_LOGIC;
		rst: in STD_LOGIC;

		Rs1_addr_in : in STD_LOGIC_VECTOR (2 downto 0);
		Rs1_data_out : out STD_LOGIC_VECTOR (13 downto 0);

		Rs2_addr_in : in STD_LOGIC_VECTOR (2 downto 0);
		Rs2_data_out : out STD_LOGIC_VECTOR (13 downto 0);

		Rd_addr_in : in STD_LOGIC_VECTOR (2 downto 0);
		Rd_data_in : in STD_LOGIC_VECTOR (13 downto 0);
		Rd_we : in STD_LOGIC
	     );
end component;

component Decoder
	port ( 	instruction_in : in STD_LOGIC_VECTOR (15 downto 0);

		opcode_out : out opcode_type;

		Rd_addr_out : out STD_LOGIC_VECTOR (2 downto 0);
		Rs1_addr_out : out STD_LOGIC_VECTOR (2 downto 0);
		Rs2_addr_out : out STD_LOGIC_VECTOR (2 downto 0);

		immediate_out : out STD_LOGIC_VECTOR (13 downto 0)
	     );
end component;

component ALU 
	port ( 	operand_1 : in STD_LOGIC_VECTOR (13 downto 0);
	 	operand_2 : in STD_LOGIC_VECTOR (13 downto 0);

	 	opcode : in opcode_type;

		result : out STD_LOGIC_VECTOR (13 downto 0);
		overflow : out STD_LOGIC
	     );
end component;

--
-- internal signals
--
-- pseudo clock for advancing processor to next instruction
signal clk_proc : STD_LOGIC;

-- display controller
signal rst_disp : STD_LOGIC;

-- TODO add other internal signals as needed

-- component instances 
--

-- instructions
signal curr_PC : STD_LOGIC_VECTOR (6 downto 0);
signal instruction : STD_LOGIC_VECTOR (15 downto 0);

signal new_PC : STD_LOGIC_VECTOR (6 downto 0);
signal PC_we : STD_LOGIC;
signal PC_incr : STD_LOGIC;

-- decoder and controller
signal opcode_internal : opcode_type;

signal Rd_addr : STD_LOGIC_VECTOR (2 downto 0);
signal Rs1_addr : STD_LOGIC_VECTOR (2 downto 0);
signal Rs2_addr : STD_LOGIC_VECTOR (2 downto 0);
signal immediate : STD_LOGIC_VECTOR (13 downto 0);

-- registers
signal Rd_data : STD_LOGIC_VECTOR (13 downto 0);
signal Rs1_data : STD_LOGIC_VECTOR (13 downto 0);
signal Rs2_data : STD_LOGIC_VECTOR (13 downto 0);
signal Rd_we : STD_LOGIC;

--display controller
signal seg_bits1 : STD_LOGIC_VECTOR (0 to 7);
signal seg_an1 : STD_LOGIC_VECTOR (3 downto 0);

-- ALU
signal operand_1_internal : STD_LOGIC_VECTOR (13 downto 0);
signal operand_2_internal : STD_LOGIC_VECTOR (13 downto 0);
signal result_internal : STD_LOGIC_VECTOR (13 downto 0);
signal overflow_ALU : STD_LOGIC;


begin

-- simple hardwired logic
--
clk_proc <= next_instr;
rst_disp <= rst or clk_proc;

-- simple wiring of global signals

seg_bits <= seg_bits1 ;			  
seg_an <= seg_an1;


Display_Controller_inst : Display_Controller
	port map (clk, rst_disp, opcode_internal, operand_1_internal, operand_2_internal, result_internal, overflow_ALU, seg_bits1, seg_an1);

-- TODO add other component instances

Instructions_ROM_inst : Instructions_ROM
	port map (curr_PC, instruction);

Decoder_inst : Decoder
	port map (instruction, opcode_internal, Rd_addr, Rs1_addr, Rs2_addr, immediate);

Controller_inst : Controller
	port map (opcode_internal, operand_1_internal, operand_2_internal, result_internal, curr_PC, new_PC, PC_we, PC_incr, Rs1_data, Rs2_data, immediate, Rd_we, Rd_data);
	
PC_inst : PC
	port map (clk_proc, rst, new_PC, curr_PC, PC_we, PC_incr);

Registers_inst : Registers
	port map (clk_proc, rst, Rs1_addr, Rs1_data, Rs2_addr, Rs2_data, Rd_addr, Rd_data, Rd_we);

ALU_inst : ALU
	port map (operand_1_internal, operand_2_internal, opcode_internal, result_internal, overflow_ALU);

end Behavioral;
