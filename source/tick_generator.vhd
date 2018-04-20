-------------------------------------------
-- Block code:  tick_generator.vhd
-- History: 	15.Nov.2018 - 1st version (guifonte)
--					22.Mar.2018 - change to Moore State Machine (guifonte)
--                 <date> - <changes>  (<author>)
-- Function: tick generator with an active input and two working modes:
--					send a tick every 10 or 20 ticks from the clock.
--					starts with the 10 tick down counter, and the subsequent cycles count 20
--					until it is set to inactive, that makes it wait to start to count 10 again
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
  PORT( clk,reset_n					: IN    	std_logic; 		
		ativo								: IN		std_logic; --continuos signal to set the working of the down counter
    	tick_o     						: OUT   	std_logic
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
  comb_logic: PROCESS(ativo,count)
  BEGIN	

	-- check if the down counter is active
	-- start counting 10 to send a tick
	-- after keep sending a tick every 20 clk ticks
	IF (ativo = '1') THEN
			next_count <= count - 1;
			IF(count = 0) THEN
				next_count <= to_unsigned(20,width);
			END IF;
	ELSE
		next_count <= to_unsigned(10,width);
	END IF;
	
  END PROCESS comb_logic;   
  
  --------------------------------------------------
  -- PROCESS FOR REGISTERS
  --------------------------------------------------
  flip_flops : PROCESS(clk, reset_n)
  BEGIN	
	IF (reset_n = '0') THEN
		count <= to_unsigned(10,width); -- convert integer value 10 to unsigned with 4bits
    ELSIF rising_edge(clk) THEN
		count <= next_count ;
    END IF;
  END PROCESS flip_flops;
  
  -------------------------------------------
  -- Concurrent Assignments  
  -------------------------------------------  
  final_logic : PROCESS(count)
  BEGIN
	IF (count = 0) THEN
		tick_o <= '1';
	ELSE
		tick_o <= '0';
	END IF;
  END PROCESS final_logic;	
  -- End Architecture 
------------------------------------------- 
END rtl;

