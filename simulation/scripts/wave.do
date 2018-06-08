onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /testbench_uart_rx_only_top/tb_test_vector
add wave -noupdate /testbench_uart_rx_only_top/tb_clock
add wave -noupdate /testbench_uart_rx_only_top/tb_reset_n
add wave -noupdate /testbench_uart_rx_only_top/tb_serdata
add wave -noupdate /testbench_uart_rx_only_top/DUT/inst_modulo_divider/clk_div
add wave -noupdate /testbench_uart_rx_only_top/DUT/inst_tick_generator/tick_o
add wave -noupdate -expand -group Sync_Edge_Detect -color {Sky Blue} -itemcolor {Sky Blue} /testbench_uart_rx_only_top/DUT/inst_sync_n_edgeDetector/data_in
add wave -noupdate -expand -group Sync_Edge_Detect -color {Sky Blue} -itemcolor {Sky Blue} /testbench_uart_rx_only_top/DUT/inst_sync_n_edgeDetector/data_out
add wave -noupdate -expand -group Sync_Edge_Detect -color {Sky Blue} -itemcolor {Sky Blue} /testbench_uart_rx_only_top/DUT/inst_sync_n_edgeDetector/rise
add wave -noupdate -expand -group Sync_Edge_Detect -color {Sky Blue} -itemcolor {Sky Blue} /testbench_uart_rx_only_top/DUT/inst_sync_n_edgeDetector/fall
add wave -noupdate -expand -group {FSM
} -color Pink -itemcolor Pink /testbench_uart_rx_only_top/DUT/inst_fsm/tick
add wave -noupdate -expand -group {FSM
} -color Pink -itemcolor Pink /testbench_uart_rx_only_top/DUT/inst_fsm/fall
add wave -noupdate -expand -group {FSM
} -color Pink -itemcolor Pink /testbench_uart_rx_only_top/DUT/inst_fsm/tick_halfsize
add wave -noupdate -expand -group {FSM
} -color Pink -itemcolor Pink /testbench_uart_rx_only_top/DUT/inst_fsm/tick_activator
add wave -noupdate -expand -group {FSM
} -color Pink -itemcolor Pink /testbench_uart_rx_only_top/DUT/inst_fsm/s_state
add wave -noupdate -expand -group {FSM
} -color Pink -itemcolor Pink /testbench_uart_rx_only_top/DUT/inst_fsm/s_nextstate
add wave -noupdate -expand -group {FSM
} -color Pink -itemcolor Pink /testbench_uart_rx_only_top/DUT/inst_fsm/clk
add wave -noupdate -expand -group {FSM
} -color Pink -itemcolor Pink /testbench_uart_rx_only_top/DUT/inst_fsm/reset_n
add wave -noupdate -expand -group {FSM
} -color Pink -itemcolor Pink /testbench_uart_rx_only_top/DUT/inst_fsm/count
add wave -noupdate -expand -group {FSM
} -color Pink -itemcolor Pink /testbench_uart_rx_only_top/DUT/inst_fsm/next_count
add wave -noupdate -expand -group {Tick_Gen
} -color {Orange Red} -itemcolor {Orange Red} /testbench_uart_rx_only_top/DUT/inst_tick_generator/clk
add wave -noupdate -expand -group {Tick_Gen
} -color {Orange Red} -itemcolor {Orange Red} /testbench_uart_rx_only_top/DUT/inst_tick_generator/reset_n
add wave -noupdate -expand -group {Tick_Gen
} -color {Orange Red} -itemcolor {Orange Red} /testbench_uart_rx_only_top/DUT/inst_tick_generator/ativo
add wave -noupdate -expand -group {Tick_Gen
} -color {Orange Red} -itemcolor {Orange Red} /testbench_uart_rx_only_top/DUT/inst_tick_generator/half
add wave -noupdate -expand -group {Tick_Gen
} -color {Orange Red} -itemcolor {Orange Red} /testbench_uart_rx_only_top/DUT/inst_tick_generator/tick_o
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {414904 ns} 0}
quietly wave cursor active 1
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
WaveRestoreZoom {0 ns} {862704 ns}
