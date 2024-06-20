library IEEE;
use IEEE.STD_LOGIC_1164.all;

package common is

attribute ENUM_ENCODING: STRING;

type opcode_type is (OP_AND, OP_ANDI, OP_OR, OP_ORI, OP_XOR, OP_XORI, OP_SLL, OP_SRL, OP_ADD, OP_ADDI, OP_SUB, OP_SUBI, OP_BLT, OP_BE, OP_JMP, OP_HALT);
attribute ENUM_ENCODING of opcode_type: type is "0000 0001 0010 0011 0100 0101 0110 0111 1000 1001 1010 1011 1100 1101 1110 1111";

function std_logic_vector_to_opcode_type ( opcode_bits : std_logic_vector(3 downto 0) ) return opcode_type;

function opcode_type_to_std_logic_vector ( opcode : opcode_type ) return std_logic_vector;

end common;

package body common is

function std_logic_vector_to_opcode_type ( opcode_bits : std_logic_vector(3 downto 0) ) return opcode_type is
begin
	case opcode_bits is
		when "0000" =>
			return OP_AND;
		when "0001" =>
			return OP_ANDI;
		when "0010" =>
			return OP_OR;
		when "0011" =>
			return OP_ORI;
		when "0100" =>
			return OP_XOR;
		when "0101" =>
			return OP_XORI;
		when "0110" =>
			return OP_SLL;
		when "0111" =>
			return OP_SRL;
		when "1000" =>
			return OP_ADD;
		when "1001" =>
			return OP_ADDI;
		when "1010" =>
			return OP_SUB;
		when "1011" =>
			return OP_SUBI;
		when "1100" =>
			return OP_BLT;
		when "1101" =>
			return OP_BE;
		when "1110" =>
			return OP_JMP;
		when "1111" =>
			return OP_HALT;
		-- any error in the opcode bits will trigger operation HALT as well
		when others =>
			return OP_HALT;
	end case;
	
end std_logic_vector_to_opcode_type;

function opcode_type_to_std_logic_vector ( opcode : opcode_type ) return std_logic_vector is
begin
	case opcode is
		when OP_AND =>
			return "0000";
		when OP_ANDI =>
			return "0001";
		when OP_OR =>
			return "0010";
		when OP_ORI =>
			return "0011";
		when OP_XOR =>
			return "0100";
		when OP_XORI =>
			return "0101";
		when OP_SLL =>
			return "0110";
		when OP_SRL =>
			return "0111";
		when OP_ADD =>
			return "1000";
		when OP_ADDI =>
			return "1001";
		when OP_SUB =>
			return "1010";
		when OP_SUBI =>
			return "1011";
		when OP_BLT =>
			return "1100";
		when OP_BE =>
			return "1101";
		when OP_JMP =>
			return "1110";
		when OP_HALT =>
			return "1111";
		-- any error in the opcode will trigger bitcode for operation HALT as well
		when others =>
			return "1111";
	end case;
	
end opcode_type_to_std_logic_vector;

end common;
