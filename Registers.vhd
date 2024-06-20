library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

use work.common.all;

--
-- LEAVE AS IS
--

entity Registers is
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
end Registers;

architecture Behavioral of Registers is

type Reg_type is array (0 to 7) of STD_LOGIC_VECTOR (13 downto 0);
signal reg : Reg_type;

begin
	Rs1_data_out <= reg ( to_integer(unsigned(Rs1_addr_in)) );
	Rs2_data_out <= reg ( to_integer(unsigned(Rs2_addr_in)) );

	reg_process : process (clk, rst)
	begin
		-- asynchronous reset
		if (rst = '1') then
			-- loop will be unrolled during synthesis
			for i in 0 to 7 loop 
				reg(i) <= (others => '0'); 
			end loop;

		-- synchronized write
		elsif (rising_edge(clk)) then

			-- writing only once Rd_we flag is on
			-- writing to reg(0) is always disabled
			if (Rd_we = '1') and (Rd_addr_in /= (2 downto 0 => '0')) then
				reg ( to_integer(unsigned(Rd_addr_in)) ) <= Rd_data_in;
			end if;
		end if;
	end process;


end Behavioral;

