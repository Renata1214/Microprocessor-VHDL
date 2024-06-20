library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

use work.common.all;

entity Decoder is
	port ( 	instruction_in : in STD_LOGIC_VECTOR (15 downto 0);

		opcode_out : out opcode_type;

		Rd_addr_out : out STD_LOGIC_VECTOR (2 downto 0);
		Rs1_addr_out : out STD_LOGIC_VECTOR (2 downto 0);
		Rs2_addr_out : out STD_LOGIC_VECTOR (2 downto 0);

		immediate_out : out STD_LOGIC_VECTOR (13 downto 0)
	     );
end Decoder;

architecture Behavioral of Decoder is

--TODO add signals as needed
signal opcode_internal : opcode_type;
signal 	Rd_addr_sig : STD_LOGIC_VECTOR (2 downto 0);
signal	Rs1_addr_sig : STD_LOGIC_VECTOR (2 downto 0);
signal	Rs2_addr_sig :  STD_LOGIC_VECTOR (2 downto 0);
signal	immediate_sig : STD_LOGIC_VECTOR (13 downto 0);


begin


	opcode_out <= opcode_internal;

	opcode_internal <= std_logic_vector_to_opcode_type( instruction_in(15 downto 12) );

	--TODO implement extraction of remaining parts of the instruction
	Rd_addr_sig <= std_logic_vector(instruction_in(11 downto 9));
	Rd_addr_out <= Rd_addr_sig;
	
	Rs1_addr_sig <= instruction_in(8 downto 6);
	Rs1_addr_out <= Rs1_addr_sig;
		
	Rs2_addr_sig <= instruction_in(5 downto 3);
	Rs2_addr_out <= Rs2_addr_sig;
	
	immediate_out <= immediate_sig;

	--TODO derive immediate value, depending on opcode_internal
decode : process (opcode_internal)
begin
	case opcode_internal is 
		when (OP_ANDI) => 
			immediate_sig <= ("11111111" & Rs2_addr_sig & instruction_in (2 downto 0));
		when (OP_ORI) =>
			immediate_sig <=  ("00000000" & Rs2_addr_sig & instruction_in (2 downto 0));
		when(OP_XORI)=>
			immediate_sig <=  ("00000000" & Rs2_addr_sig & instruction_in (2 downto 0));
		when (OP_SLL ) =>
			immediate_sig <= ("00000000000" & instruction_in (2 downto 0));
		when (OP_SRL) =>
			immediate_sig <= ("00000000000" & instruction_in (2 downto 0));
			
		when (OP_ADDI) =>
			if instruction_in (5) = '1' then 
			immediate_sig <= ("11111111" & Rs2_addr_sig & instruction_in (2 downto 0)); 
			else 
			immediate_sig <= ("00000000" & Rs2_addr_sig & instruction_in (2 downto 0)); 
			end if;
			--CHECK
		when (OP_SUBI) =>
			if instruction_in (5) = '1' then
			immediate_sig <= ("11111111" & Rs2_addr_sig & instruction_in (2 downto 0));
			else
			immediate_sig <= ("00000000" & Rs2_addr_sig & instruction_in (2 downto 0)); --CHECK
			end if;
		when (OP_BLT) =>
		
			if instruction_in (5) = '1' then 
			immediate_sig <= ("11111111" & Rd_addr_sig & instruction_in (2 downto 0));
			else
			immediate_sig <= ("00000000" & Rd_addr_sig & instruction_in (2 downto 0)); --CHECK
			end if;
			
		when (OP_BE) =>
			if instruction_in (5) = '1' then 
			immediate_sig <= ("11111111" & Rd_addr_sig & instruction_in (2 downto 0));
			else
			immediate_sig <= ("00000000" & Rd_addr_sig & instruction_in (2 downto 0)); --CHECK
			end if;
			
		when (OP_JMP) =>
			if instruction_in (5) = '1' then 
			immediate_sig <= ("11111111" & Rd_addr_sig & instruction_in (2 downto 0));
			else
			immediate_sig <= ("00000000" & Rd_addr_sig & instruction_in (2 downto 0)); --CHECK
			end if;
			
		when others => 
			immediate_sig <= "00000000000000";
			
	end case;
	

	
	end process;


end Behavioral;