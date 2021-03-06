-------------------------------------------
-- Block code:  rx_register_s2p.vhd
-- History: 	12.Nov.2013 - 1st version (dqtm)
--                 <date> - <changes>  (<author>)
-- Function: shift-register working as a parallel to serial converter.
--			The block has a load( or shift_n) control input, plus a parallel data input.
--			If load is high the parallel data is loaded, and if load is low the data is shifted towards the LSB.
--			During shift the MSB gets the value of '1'.
--			The serial output is the LSB of the shiftregister.  
--			Can be used as P2S in a serial interface, where inactive value (or rest_value)  equals '1'.
-------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY rx_register_s2p IS
  PORT( clk,reset_n: 						IN    std_logic;			-- Attention, this block has a set_n input for initialisation!!
  		activator: 								IN    std_logic;
  		par_bit0_o, par_bit1_o: 			OUT   std_logic_vector(3 downto 0);
    	ser_i: 									IN   	std_logic;
		led_o: 									OUT	std_logic
    	);
END rx_register_s2p;

ARCHITECTURE rtl OF rx_register_s2p IS
-- Signals & Constants Declaration
-------------------------------------------
	SIGNAL 		shiftreg, next_shiftreg: 	std_logic_vector(9 downto 0);	 -- add one FF for start_bit 0
BEGIN

  --------------------------------------------------
  -- PROCESS FOR COMBINATIONAL LOGIC
  --------------------------------------------------
  shift_comb: PROCESS(shiftreg, ser_i, activator)
  BEGIN	
  next_shiftreg <= shiftreg;
  --loading 1 bit (serial)
	IF (activator = '1') THEN			  -- load serial data (startbit 0)
		next_shiftreg <= ser_i & shiftreg(9 downto 1 ); -- LSB='0' is the start_bit
  	END IF;
	
  END PROCESS shift_comb;   
  
  --------------------------------------------------
  -- PROCESS FOR REGISTERS
  --------------------------------------------------
  shift_dffs : PROCESS(clk, reset_n)
  BEGIN	
	IF reset_n = '0' THEN
		shiftreg <= (others=>'0');
   ELSIF rising_edge(clk) THEN
		shiftreg <= next_shiftreg ;
   END IF;
  END PROCESS shift_dffs;		
  
  --------------------------------------------------
  -- CONCURRENT ASSIGNMENTS
  --------------------------------------------------
  -- take LSB of shiftreg as serial output
  led_comb : PROCESS(shiftreg)
  BEGIN
	IF (shiftreg(9) = '1' AND shiftreg(0) = '0') THEN
		par_bit0_o <= shiftreg(4 downto 1);
		par_bit1_o <= shiftreg(8 downto 5);
		led_o <= '0';
	ELSE
		led_o <= '1';
		par_bit0_o <= (others=> '0');
		par_bit1_o <= (others=> '0');
	END IF;
  END PROCESS led_comb;

END rtl;

