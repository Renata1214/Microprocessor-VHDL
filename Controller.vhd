library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

use work.common.all;

entity Controller is
	port ( 	opcode : in opcode_type; --operation to be carried out by alu

	 	operand_1 : out STD_LOGIC_VECTOR (13 downto 0); --14bit to output to register
	 	operand_2 : out STD_LOGIC_VECTOR (13 downto 0); --14bit to output to register

	 	result : in STD_LOGIC_VECTOR (13 downto 0); --returned from register file

		curr_PC : in STD_LOGIC_VECTOR (6 downto 0); --incremented or sent to branch based on opcode

		new_PC : out STD_LOGIC_VECTOR (6 downto 0);
		PC_we : out STD_LOGIC; --enable signal for PC (true or false)
		PC_incr : out STD_LOGIC; --if not invlolving branch

		Rs1_data : in STD_LOGIC_VECTOR (13 downto 0); --14bit input operand rs1
		Rs2_data : in STD_LOGIC_VECTOR (13 downto 0); --14 bit input rs2
		immediate : in STD_LOGIC_VECTOR (13 downto 0); -- immediate value if any recieved from decoder

		Rd_we : out STD_LOGIC; --enable signal for Rd (true or false)
		Rd_data : out STD_LOGIC_VECTOR (13 downto 0) --output data to be stored in rd location
	     );
end Controller;

architecture Behavioral of Controller is

begin

control : process (opcode, Rs1_data, Rs2_data, result, immediate, curr_PC)
begin
	-- default assignments, can be overwritten below
	operand_1 <= Rs1_data;
	operand_2 <= Rs2_data;

	Rd_we <= '0';
	Rd_data <= result;

	PC_we <= '0';
	new_PC <= (6 downto 0 => 'X');
	PC_incr <= '0';

	-- regular operations with Rs1, Rs2, Rd
	-- TODO consider remaining cases
	if ((opcode = OP_ADD) or (opcode = OP_OR)  or (opcode = OP_XOR) or (opcode = OP_AND)  or (opcode = OP_SUB)) then

		Rd_we <= '1';
		PC_incr <= '1';

	-- TODO implement remaining cases
	elsif ((opcode = OP_ADDI) or (opcode = OP_ORI)  or (opcode = OP_XORI) or (opcode = OP_SLL)  or (opcode = OP_SRL)or (opcode = OP_ANDI)or (opcode = OP_SUBI) ) then 
		operand_2 <= immediate;
		Rd_we <= '1';
		PC_incr <= '1';
		
	elsif (opcode = OP_BE) then
		Rd_we <= '0';
		if (Rs1_data = Rs2_data) then 
			operand_1 <= ("0000000" & curr_PC);
			operand_2 <= immediate;
			new_PC <= result(6 downto 0);
			PC_we <= '1';
		else
			PC_incr <= '1';
			PC_we <= '0';
		end if;
		
	elsif (opcode = OP_BLT) then
		Rd_we <= '0';
		if (Rs1_data < Rs2_data) then 
			operand_1 <= ("0000000" & curr_PC);
			operand_2 <= immediate;
			new_PC <= std_logic_vector(result(6 downto 0));
			PC_we <= '1';
		else
			PC_we <= '0';
			PC_incr <= '1';
		end if;
	
	elsif (opcode = OP_JMP) then
		Rd_we <= '0';
		PC_we <= '1';
		operand_1 <= ("0000000" & curr_PC);
		operand_2 <= immediate;
		new_PC <= std_logic_vector(result(6 downto 0));

	-- only OP_HALT should remain
	else
		operand_1 <= (13 downto 0 => 'X');
		operand_2 <= (13 downto 0 => 'X');

		Rd_data <= (13 downto 0 => 'X');
	end if;
end process;

end Behavioral;

