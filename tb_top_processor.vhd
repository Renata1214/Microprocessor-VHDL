LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

use work.common.all;

ENTITY tb_top_processor IS
END tb_top_processor;
 
ARCHITECTURE behavior OF tb_top_processor IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT top_processor
    PORT(
         clk : IN  std_logic;
         rst : IN  std_logic;
         operand_1 : OUT  std_logic_vector(13 downto 0);
         operand_2 : OUT  std_logic_vector(13 downto 0);
         opcode : OUT  opcode_type;
         result : OUT  std_logic_vector(13 downto 0);
         overflow : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal rst : std_logic := '0';

 	--Outputs
   signal operand_1 : std_logic_vector(13 downto 0);
   signal operand_2 : std_logic_vector(13 downto 0);
   signal opcode : opcode_type;
   signal result : std_logic_vector(13 downto 0);
   signal overflow : std_logic;

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
   -- Instantiate the Unit Under Test (UUT)
   uut: top_processor PORT MAP (
          clk => clk,
          rst => rst,
          operand_1 => operand_1,
          operand_2 => operand_2,
          opcode => opcode,
          result => result,
          overflow => overflow
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      rst <= '1';
      wait for 100 ns;	

      rst <= '0';
		
      -- insert stimulus here
      --
      -- not required; processor runs by itself
		
      wait;
   end process;

END;
