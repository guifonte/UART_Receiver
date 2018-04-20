-------------------------------------------
-- Block code:  fsm.vhd
-- History: 	23.Nov.2017 - 1st version (dqtm)
--                   <date> - <changes>  (<author>)
-- Function: fsm_example using enumerated type declaration. 
-------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY fsm IS
GENERIC (width : positive := 4);
	PORT (
		clk,reset_n : 	   	IN std_logic;
		tick, fall :        	IN std_logic;
		tick_activator:		OUT std_logic
	);
END fsm;


ARCHITECTURE rtl OF fsm IS
	--TYPE t_state IS (begining, not_begining);		-- declaration of new datatype
	--SIGNAL s_state, s_nextstate :  t_state; -- 2 signals of the new datatype
	SIGNAL count, next_count : unsigned(3 downto 0); -- bitcounter (message = 10 bits)

BEGIN

  --------------------------------------------------
  -- PROCESS FOR COMB-INPUT LOGIC
  --------------------------------------------------
  --State machine devided in 2 states: begining and not begining
  --when begining tells the counter to count only 10 counts
  --else tells the counter to count 20 counts
  --count tells in which bit the message is 
  --if count = 0 no message has been sent, if count = 11, the message is over
  fsm_drive :PROCESS (tick, fall, count)
  BEGIN
  	-- Default Statement
	--s_nextstate <= s_state;
   --next_count <= count;
   --tick_activator <= '0';
	
	IF (count = 0) THEN
		IF (fall = '1') THEN
			next_count <= count + 1;
		ELSE
			next_count <= to_unsigned(0,width);
		END IF;
	ELSIF (count = 10) THEN
		next_count <= to_unsigned(0,width);
	ELSE
		IF (tick = '1') THEN
			next_count <= count + 1;
		ELSE
			next_count <= count;
		END IF;
	END IF;
  END PROCESS fsm_drive;
 
 
  --------------------------------------------------
  -- PROCESS FOR REGISTERS
  --------------------------------------------------
  flip_flops :PROCESS (clk, reset_n)
  BEGIN
  	IF (reset_n = '0') THEN
		count <= to_unsigned(0,width);
  	ELSIF rising_edge(clk) THEN
		--s_state <= s_nextstate;
		count <= next_count;
  	END IF;
  END PROCESS flip_flops;
  
  --------------------------------------------------
  -- CONCURRENT ASSIGNMENTS
  --------------------------------------------------
  final_logic :PROCESS (count)
  BEGIN
	IF (count = 0) THEN
		tick_activator <= '0';
	ELSE
		tick_activator <= '1';
	END IF;
  END PROCESS final_logic;
  
END rtl;