LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY UART_Receiver_top IS
	PORT(
	clock_50Mhz 					: IN std_logic;
	rst_n								: IN std_logic;
	data_input						: IN std_logic;
	load_rx							: IN std_logic;
	hex_o_1,hex_o_2				: OUT std_logic_vector(6 downto 0)
	);
END UART_Receiver_top;


ARCHITECTURE struct OF UART_Receiver_top IS

	COMPONENT tick_generator
	PORT(
	clk,reset_n						: IN    	std_logic; 		
	ativo								: IN		std_logic;
	tick_o     						: OUT   	std_logic);
	END COMPONENT;
	
	COMPONENT fsm
	PORT (
	clk,reset_n 					: 	IN 	std_logic;
	tick, fall 						:	IN 	std_logic;
	tick_activator					:	OUT 	std_logic);
	END COMPONENT;
	
	COMPONENT modulo_divider
	PORT( 
	clk,reset_n						:	IN    std_logic;
   clk_div     					: 	OUT   std_logic);
	END COMPONENT;
	
	COMPONENT rx_register_s2p
	PORT( 
	clk,set_n						: 	IN    std_logic;
  	load_i							: 	IN    std_logic;
  	par_bit0_o, par_bit1_o		: 	OUT   std_logic_vector(3 downto 0);
   ser_i								: 	IN   	std_logic);
	END COMPONENT;
	
	COMPONENT sync_n_edgeDetector
	PORT( 
	data_in 							:	IN    std_logic;
	clock								:	IN    std_logic;
	reset_n							:	IN    std_logic;
	data_out							:	OUT	std_logic; 
   rise   						 	:	OUT   std_logic;
	fall     						:	OUT   std_logic);
	END COMPONENT;
	
	--COMPONENT hex2sevseg_w_control
	--PORT(
  	--blank_n_i						: 	IN 	std_logic;
  	--lamp_test_n_i					: 	IN		std_logic;
  	--ripple_blank_n_i				:	IN 	std_logic;	
	--hexa_i							: 	IN  	std_logic_vector(3 downto 0);  
	--ripple_blank_n_o				:	OUT 	std_logic;
	--seg_o								: 	OUT 	std_logic_vector(6 downto 0));
	--END COMPONENT;
	
	SIGNAL sync2fsm,sync2rx		: 	std_logic;
	SIGNAL tick_out,fsm2tick	: 	std_logic;
	SIGNAL mod_clk					: 	std_logic;
	SIGNAL ripple_blank			: 	std_logic;
	SIGNAL rx2hex1,rx2hex2	 	: 	std_logic_vector(3 downto 0);
	
	CONSTANT fix_1 				: 	std_logic := '1';
	
	BEGIN
		inst_sync_n_edgeDetector: sync_n_edgeDetector
		PORT MAP( 
					data_in 			=>		data_input,					
					clock				=>		mod_clk,
					reset_n			=>		rst_n,	
					data_out			=>		sync2rx,	
					--rise   						 	
					fall     		=>		sync2fsm	
					);
					
		inst_modulo_divider : modulo_divider
		PORT MAP( 
					clk				=>		clock_50Mhz,
					reset_n			=>		rst_n,						
					clk_div     	=>		mod_clk					
					);
					
		inst_tick_generator : tick_generator
		PORT MAP(
					clk				=>		mod_clk,
					reset_n			=>		rst_n,					
					ativo				=>		fsm2tick,					
					tick_o     		=>		tick_out					
					);
		
		inst_fsm : fsm
		PORT MAP (
					clk				=>		mod_clk,
					reset_n 			=>		rst_n,					
					tick				=>		tick_out,
					fall 				=>		sync2fsm,	
					tick_activator	=>		fsm2tick				
					);
					
		inst_rx_register_s2p : rx_register_s2p
		PORT MAP( 
					clk     			=>		tick_out,
					set_n				=>		rst_n,		
					load_i			=>		fix_1,
					par_bit0_o		=>		rx2hex1,
					par_bit1_o		=>		rx2hex2,
					ser_i				=>		sync2rx								
					);
					
		--inst_hex2sevseg_w_control_1 : hex2sevseg_w_control
		--PORT MAP(
					--blank_n_i						
					--lamp_test_n_i				
					--ripple_blank_n_i	
					--hexa_i					=>		rx2hex1,  
					--ripple_blank_n_o		=>		ripple_blank,
					--seg_o						=>		hex_o_1
					--);	
		
		--inst_hex2sevseg_w_control_2 : hex2sevseg_w_control
		--PORT MAP(
					--blank_n_i						
					--lamp_test_n_i				
					--ripple_blank_n_o	
					--hexa_i					=>		rx2hex2,  
					--ripple_blank_n_i		=>		ripple_blank,
					--seg_o						=>		hex_o_2
					--);					
					
	END struct;