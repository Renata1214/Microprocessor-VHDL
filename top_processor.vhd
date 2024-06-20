library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

use work.common.all;

entity top_processor is
	port ( clk : in STD_LOGIC;
		rst : in STD_LOGIC;

	 	operand_1 : out STD_LOGIC_VECTOR (13 downto 0);
	 	operand_2 : out STD_LOGIC_VECTOR (13 downto 0);

		opcode : out opcode_type;

		result : out STD_LOGIC_VECTOR (13 downto 0);
		
		overflow : out STD_LOGIC
	);
end top_processor;

architecture Behavioral of top_processor is

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

-- ALU
signal operand_1_internal : STD_LOGIC_VECTOR (13 downto 0);
signal operand_2_internal : STD_LOGIC_VECTOR (13 downto 0);
signal result_internal : STD_LOGIC_VECTOR (13 downto 0);

begin

-- simple wiring of global signals
operand_1 <= operand_1_internal;
operand_2 <= operand_2_internal;
result <= result_internal;
opcode <= opcode_internal;

--
-- component instances with port maps; nothing else is allowed for this top-level module
--

Instructions_ROM_inst : Instructions_ROM
	port map (curr_PC, instruction);

Decoder_inst : Decoder
	port map (instruction, opcode_internal, Rd_addr, Rs1_addr, Rs2_addr, immediate);

Controller_inst : Controller
	port map (opcode_internal, operand_1_internal, operand_2_internal, result_internal, curr_PC, new_PC, PC_we, PC_incr, Rs1_data, Rs2_data, immediate, Rd_we, Rd_data);
	
PC_inst : PC
	port map (clk, rst, new_PC, curr_PC, PC_we, PC_incr);

Registers_inst : Registers
	port map (clk, rst, Rs1_addr, Rs1_data, Rs2_addr, Rs2_data, Rd_addr, Rd_data, Rd_we);

ALU_inst : ALU
	port map (operand_1_internal, operand_2_internal, opcode_internal, result_internal, overflow);

end Behavioral;
