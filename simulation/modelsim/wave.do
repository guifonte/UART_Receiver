onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /testbench_uart_rx_only_top/tb_test_vector
add wave -noupdate /testbench_uart_rx_only_top/tb_clock
add wave -noupdate /testbench_uart_rx_only_top/tb_reset_n
add wave -noupdate /testbench_uart_rx_only_top/tb_serdata
add wave -noupdate /testbench_uart_rx_only_top/DUT/inst_modulo_divider/clk_div
add wave -noupdate /testbench_uart_rx_only_top/DUT/inst_tick_generator/tick_o
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ns} 0}
quietly wave cursor active 0
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ns} {443730 ns}
