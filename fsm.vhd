-------------------------------------------
-- Block code:  fsm_example.vhd
-- History: 	23.Nov.2017 - 1st version (dqtm)
--                   <date> - <changes>  (<author>)
-- Function: fsm_example using enumerated type declaration. 
-------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY fsm IS
	PORT (
		clk,reset : 	   	IN std_logic;
		tick, fall :        IN std_logic;
		tick_output :       OUT std_logic
		tick_set_n:			OUT std_logic
	);
END fsm;


ARCHITECTURE rtl OF fsm IS
	TYPE t_state IS (begining, not_begning);		-- declaration of new datatype
	SIGNAL s_state, s_nextstate :  t_state; -- 2 signals of the new datatype
	SIGNAL count, next_count : unsigned(3 downto zero); -- bitcounter (message = 10 bits)

BEGIN

  --------------------------------------------------
  -- PROCESS FOR COMB-INPUT LOGIC
  --------------------------------------------------
  --State machine devided in 2 states: bening and not beginin
  --when bening tells the counter to count only 10 counts
  --else tells the counter to count 20 counts
  --count tells in which bit the message is 
  --if count = 0 no message has been sent, if count = 11, the message is over
  fsm_drive : PROCESS (s_state, tick, fall, count)
  BEGIN
  	-- Default Statement
  	s_nextstate <= s_state;
    next_count <= count;
  
  	CASE s_state IS

  		WHEN not_begning => 
        -- to begin a message 
        --untill it begins, count is 11 (if a previous message has been sent)
        --or clock is 0 if no message has been sent at all
  			IF (fall) AND ((count = 0) OR (count >10)) THEN
			tick_output <= '1';
			s_nextstate <= begining
			count <= 1;
			tick_set_n <= '0';
        --if the message is being sent
  			ELSIF (tick = '1') AND (count <= 10) THEN
            next_count <= count + 1;
            tick_output <= '0';
			tick_set_n <= '0';
		--if the message is already sent
			ELSIF (tick = '1') AND (count > 10) THEN 
			tick_set_n <= '1';
  			END IF;

      --to send the ticker the bit to switch clock counter from 10 counts to 20 
  		WHEN begining =>
        IF  (tick = '1') THEN
			s_nextstate <= not_begining
			tick_output <= '0';
			tick_set_n <= '0';
        END IF;

  		WHEN OTHERS => 
  			s_nextstate <= not_begining;
  	END CASE;
  END PROCESS fsm_drive;
 
 
  --------------------------------------------------
  -- PROCESS FOR REGISTERS
  --------------------------------------------------
  flip_flops :PROCESS (clk, reset)
  BEGIN
  	IF (reset = '1') THEN
  		s_state <= not_begining;
		count <= to_unsigned(0,4);
  	ELSIF rising_edge(clk) THEN
		s_state <= s_nextstate;
		count <= next_count;
  	END IF;
  END PROCESS flip_flops;
  
  END rtl;
