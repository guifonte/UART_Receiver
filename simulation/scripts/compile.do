# create work library
# vlib work

# compile project files
vcom -2008 -explicit -work work ../../source/tick_generator.vhd
vcom -2008 -explicit -work work ../../source/fsm.vhd
vcom -2008 -explicit -work work ../../source/modulo_divider.vhd
vcom -2008 -explicit -work work ../../source/rx_register_s2p.vhd
vcom -2008 -explicit -work work ../../source/sync_n_edgeDetector.vhd
vcom -2008 -explicit -work work ../../source/hex2sevseg.vhd
vcom -2008 -explicit -work work ../../source/uart_rx_only_top.vhd
vcom -2008 -explicit -work work ../../source/testbench_uart_rx_only_top.vhd

# run the simulation
vsim -novopt -t 1ns -lib work work.testbench_uart_rx_only_top
do ../scripts/wave.do
run 800.0 us
