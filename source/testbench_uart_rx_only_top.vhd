-------------------------------------------
-- Block code:  testbench_uart_rx_only_top.vhd
-- History: 	13.Mar.2018 - 1st version (dqtm)
--                 <date> - <changes>  (<author>)
-- Function: Testbench for uart_rx_only_top in EA999 - Lab2
--           
-------------------------------------------

-- Library & Use Statements
LIBRARY ieee;
use ieee.std_logic_1164.all;

-- Entity Declaration 
ENTITY testbench_uart_rx_only_top IS
  
END testbench_uart_rx_only_top ;


-- Architecture Declaration 
ARCHITECTURE struct OF testbench_uart_rx_only_top IS

	-- Components Declaration
COMPONENT uart_rx_only_top
	PORT
	(
		CLOCK_50 :  IN   STD_LOGIC;
		GPIO_1 :  IN   STD_LOGIC_VECTOR(35 DOWNTO 0);
		KEY :   	IN   STD_LOGIC_VECTOR(3 DOWNTO 0);
		HEX0 :    	OUT  STD_LOGIC_VECTOR(6 DOWNTO 0);
		HEX1 :    	OUT  STD_LOGIC_VECTOR(6 DOWNTO 0);
		LEDR :    OUT  STD_LOGIC_VECTOR(9 DOWNTO 0)
	);
END COMPONENT;	
	
	
	-- Signals & Constants Declaration 
	-- Inputs
	SIGNAL tb_clock 	: std_logic;
	SIGNAL tb_reset_n 	: std_logic;
	SIGNAL tb_serdata	: std_logic;
	
	-- AUXILIARY DUMMY SIGNALS TO COPE WITH INPUT VECTORS
	SIGNAL tb_aux_35b : std_logic_vector( 34 downto 0) := (OTHERS => '0');
	SIGNAL tb_aux_3b : std_logic_vector( 2 downto 0):= (OTHERS => '0');
	SIGNAL tb_aux_9b : std_logic_vector( 8 downto 0);
	
	-- Outputs
	SIGNAL tb_ledr		: std_logic;
	SIGNAL tb_hex_0		: std_logic_vector(6 downto 0);
	SIGNAL tb_hex_1		: std_logic_vector(6 downto 0);
	
	CONSTANT clk_50M_halfp 	: time := 10 ns;  		-- Half-Period of Clock 50MHz
	CONSTANT baud_31k250_per : time := 32 us;		-- One-Period of Baud Rate 31.25KHz
	
	SIGNAL tb_reg0_hi	: std_logic_vector(3 downto 0); -- to check DUT-internal signal
	SIGNAL tb_reg0_lo	: std_logic_vector(3 downto 0);

	SIGNAL tb_test_vector : std_logic_vector(9 downto 0); -- (stop-bit)+(data-byte)+(start-bit) to shift in serial_in
	
BEGIN
  -- Instantiations
  DUT: uart_rx_only_top
  PORT MAP (
	CLOCK_50			=>	tb_clock ,
    GPIO_1(35 downto 1) =>	tb_aux_35b,
	GPIO_1(0)			=>	tb_serdata ,
	KEY(3 downto 1)	    =>	tb_aux_3b ,
	KEY(0)	    		=>	tb_reset_n ,
    HEX0	    		=>	tb_hex_0 ,
    HEX1	    		=>	tb_hex_1 ,
	LEDR(9 downto 1) 	=>	tb_aux_9b,
	LEDR(0)			 	=> tb_ledr 
		);
		
  -- Clock Generation Process	
	generate_clock: PROCESS
	BEGIN
		tb_clock <= '1';
		wait for clk_50M_halfp;	
		tb_clock <= '0';
		wait for clk_50M_halfp;
	END PROCESS generate_clock;
	
		
	-------------------------------------------
	-- VHDL-2008 Syntax allowing to bind 
	--           internal signals to a debug signal in the testbench
	-------------------------------------------
	tb_reg0_hi <= <<signal DUT.rx2hex1 : std_logic_vector(3 downto 0) >>;
	tb_reg0_lo <= <<signal DUT.rx2hex2 : std_logic_vector(3 downto 0) >>;
	
	
  -- Stimuli Process
	stimuli: PROCESS
	BEGIN
		-- STEP 0
		report "Initialise: define constants and pulse reset on/off";
		tb_serdata <= '1';
		tb_test_vector <= B"1_0001_0010_0"; -- (stop-bit)+(data-byte)+(start-bit)
		----------------
		tb_reset_n <= '0';
		wait for 20 * clk_50M_halfp; 
		tb_reset_n <= '1';
		wait for 100 us;  -- introduce pause to check HW-bug after reset release
		
		-- STEP 1
		report "Send (start-bit)+(data-byte)+(stop-bit) with baud rate 31250 (async from clk50M)";
		wait for 200 * clk_50M_halfp;
		
		-- shift-direction is LSB first
		-- START-BIT 
		-- BIT-0 (LSB-first of lower nibbl
		-- BIT-1
		-- ...
		-- BIT-7
		-- STOP-BIT
		-- SERDATA BACK TO INACTIVE
		for I in 0 to 9 loop
			tb_serdata <= tb_test_vector(I);
			wait for baud_31k250_per;
		end loop;
		
		-- STEP 2
		report "Wait few clock_50M periods and check parallel output";
		wait for 20 * clk_50M_halfp;
		assert (tb_reg0_hi = x"1") report "Reg_0 Lower Nibble Wrong" severity note;
		assert (tb_reg0_lo = x"2") report "Reg_0 Lower Nibble Wrong" severity note;
		wait for 20 * clk_50M_halfp;
		
		-- stop simulation
		assert false report "All tests passed!" severity failure;
		
	END PROCESS stimuli;
	
	-- Comments:
	-- remember to re-save wave.do after setting radix and time ranges
	-- use >wave>format>toggle leaf names  to display shorter names
	-- remark syntax with aux debug signal to track in TB internal DUT signals
  
END struct;

