-------------------------------------------
-- Block code:  tick_generator.vhd
-- History: 	15.Nov.2018 - 1st version (guifonte)
--                 <date> - <changes>  (<author>)
-- Function: tick generator with an set input and two working modes:
--			send a tick every 10 or 20 ticks from the clock.
-------------------------------------------


-- Library & Use Statements
-------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;


-- Entity Declaration 
-------------------------------------------
ENTITY tick_generator IS
GENERIC (width : positive := 5);
  PORT( clk,set_n		: IN    std_logic;
		set_10_ticks	: IN	std_logic;
    	tick_o     		: OUT   std_logic;
    	);
END tick_generator;


-- Architecture Declaration
-------------------------------------------
ARCHITECTURE rtl OF tick_generator IS
-- Signals & Constants Declaration
-------------------------------------------
SIGNAL 		count, next_count: 	unsigned(width-1 downto 0);	 


-- Begin Architecture
-------------------------------------------
BEGIN

  --------------------------------------------------
  -- PROCESS FOR COMBINATORIAL LOGIC
  --------------------------------------------------
  comb_logic: PROCESS(count,set_10_ticks)
  BEGIN	
	-- check if should count 10 or 20 clock ticks
	-- set the output to 1 for one clock period when completes to count the 10 or 20 clock ticks
	IF (set_10_ticks = '1') THEN
		IF(count >= 10) THEN
			tick_o <= '1';
			count <= to_unsigned(0,width);
		ELSE
			tick_o <= '0';
			next_count <= count + 1 ;
		END IF;
	ELSE
		IF(count >= 20) THEN
			tick_o <= '1';
			count <= to_unsigned(0,width);
		ELSE
			tick_o <= '0';
			next_count <= count + 1 ;
		END IF;
	END IF;
	
  END PROCESS comb_logic;   
  
  
  --------------------------------------------------
  -- PROCESS FOR REGISTERS
  --------------------------------------------------
  flip_flops : PROCESS(clk, set_n)
  BEGIN	
  	IF set_n = '1' THEN
		count <= to_unsigned(0,width); -- convert integer value 0 to unsigned with 4bits
    ELSIF rising_edge(clk) THEN
		count <= next_count ;
    END IF;
  END PROCESS flip_flops;		
  
 -- End Architecture 
------------------------------------------- 
END rtl;

