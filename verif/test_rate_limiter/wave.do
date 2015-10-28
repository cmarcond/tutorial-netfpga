onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -format Literal /testbench/u_board/nf2_top/nf2_core/user_data_path/drop_nth_packet/in_data
add wave -noupdate -format Literal /testbench/u_board/nf2_top/nf2_core/user_data_path/drop_nth_packet/in_ctrl
add wave -noupdate -format Logic /testbench/u_board/nf2_top/nf2_core/user_data_path/drop_nth_packet/in_wr
add wave -noupdate -format Logic /testbench/u_board/nf2_top/nf2_core/user_data_path/drop_nth_packet/in_rdy
add wave -noupdate -format Literal /testbench/u_board/nf2_top/nf2_core/user_data_path/drop_nth_packet/out_data
add wave -noupdate -format Literal /testbench/u_board/nf2_top/nf2_core/user_data_path/drop_nth_packet/out_ctrl
add wave -noupdate -format Logic /testbench/u_board/nf2_top/nf2_core/user_data_path/drop_nth_packet/out_wr
add wave -noupdate -format Logic /testbench/u_board/nf2_top/nf2_core/user_data_path/drop_nth_packet/out_rdy
add wave -noupdate -format Logic /testbench/u_board/nf2_top/nf2_core/user_data_path/drop_nth_packet/reg_req_in
add wave -noupdate -format Logic /testbench/u_board/nf2_top/nf2_core/user_data_path/drop_nth_packet/reg_ack_in
add wave -noupdate -format Logic /testbench/u_board/nf2_top/nf2_core/user_data_path/drop_nth_packet/reg_rd_wr_L_in
add wave -noupdate -format Literal /testbench/u_board/nf2_top/nf2_core/user_data_path/drop_nth_packet/reg_addr_in
add wave -noupdate -format Literal /testbench/u_board/nf2_top/nf2_core/user_data_path/drop_nth_packet/reg_data_in
add wave -noupdate -format Literal /testbench/u_board/nf2_top/nf2_core/user_data_path/drop_nth_packet/reg_src_in
add wave -noupdate -format Logic /testbench/u_board/nf2_top/nf2_core/user_data_path/drop_nth_packet/reg_req_out
add wave -noupdate -format Logic /testbench/u_board/nf2_top/nf2_core/user_data_path/drop_nth_packet/reg_ack_out
add wave -noupdate -format Logic /testbench/u_board/nf2_top/nf2_core/user_data_path/drop_nth_packet/reg_rd_wr_L_out
add wave -noupdate -format Literal /testbench/u_board/nf2_top/nf2_core/user_data_path/drop_nth_packet/reg_addr_out
add wave -noupdate -format Literal /testbench/u_board/nf2_top/nf2_core/user_data_path/drop_nth_packet/reg_data_out
add wave -noupdate -format Literal /testbench/u_board/nf2_top/nf2_core/user_data_path/drop_nth_packet/reg_src_out
add wave -noupdate -format Logic /testbench/u_board/nf2_top/nf2_core/user_data_path/drop_nth_packet/reset
add wave -noupdate -format Logic /testbench/u_board/nf2_top/nf2_core/user_data_path/drop_nth_packet/clk
add wave -noupdate -format Literal /testbench/u_board/nf2_top/nf2_core/user_data_path/drop_nth_packet/state
add wave -noupdate -format Literal /testbench/u_board/nf2_top/nf2_core/user_data_path/drop_nth_packet/next_state
add wave -noupdate -format Literal /testbench/u_board/nf2_top/nf2_core/user_data_path/drop_nth_packet/in_fifo_data
add wave -noupdate -format Literal /testbench/u_board/nf2_top/nf2_core/user_data_path/drop_nth_packet/in_fifo_ctrl
add wave -noupdate -format Logic /testbench/u_board/nf2_top/nf2_core/user_data_path/drop_nth_packet/in_fifo_nearly_full
add wave -noupdate -format Logic /testbench/u_board/nf2_top/nf2_core/user_data_path/drop_nth_packet/in_fifo_empty
add wave -noupdate -format Logic /testbench/u_board/nf2_top/nf2_core/user_data_path/drop_nth_packet/in_fifo_rd_en
add wave -noupdate -format Logic /testbench/u_board/nf2_top/nf2_core/user_data_path/drop_nth_packet/in_fifo_rd_en_2
add wave -noupdate -format Logic /testbench/u_board/nf2_top/nf2_core/user_data_path/drop_nth_packet/out_wr_int
add wave -noupdate -format Literal /testbench/u_board/nf2_top/nf2_core/user_data_path/drop_nth_packet/drop_nth_packet_en_reg
add wave -noupdate -format Literal /testbench/u_board/nf2_top/nf2_core/user_data_path/drop_nth_packet/drop_nth_packet_reg
add wave -noupdate -format Literal /testbench/u_board/nf2_top/nf2_core/user_data_path/drop_nth_packet/drop_nth_packet_en_reg_prev
add wave -noupdate -format Literal /testbench/u_board/nf2_top/nf2_core/user_data_path/drop_nth_packet/drop_nth_packet_reg_prev
add wave -noupdate -format Literal /testbench/u_board/nf2_top/nf2_core/user_data_path/drop_nth_packet/drop_nth_packet
add wave -noupdate -format Logic /testbench/u_board/nf2_top/nf2_core/user_data_path/drop_nth_packet/rst_counter
add wave -noupdate -format Logic /testbench/u_board/nf2_top/nf2_core/user_data_path/drop_nth_packet/rst_pktcounter
add wave -noupdate -format Logic /testbench/u_board/nf2_top/nf2_core/user_data_path/drop_nth_packet/inc_counter
add wave -noupdate -format Logic /testbench/u_board/nf2_top/nf2_core/user_data_path/drop_nth_packet/inc_pktcounter
add wave -noupdate -format Literal /testbench/u_board/nf2_top/nf2_core/user_data_path/drop_nth_packet/counter
add wave -noupdate -format Literal /testbench/u_board/nf2_top/nf2_core/user_data_path/drop_nth_packet/pktcounter
add wave -noupdate -format Literal /testbench/u_board/nf2_top/nf2_core/user_data_path/drop_nth_packet/clkcounter
add wave -noupdate -format Logic /testbench/u_board/nf2_top/nf2_core/user_data_path/drop_nth_packet/rst_counter_state
add wave -noupdate -format Logic /testbench/u_board/nf2_top/nf2_core/user_data_path/drop_nth_packet/rst_counter_reg
add wave -noupdate -format Literal /testbench/u_board/nf2_top/nf2_core/user_data_path/drop_nth_packet/pick_packet0_reg
add wave -noupdate -format Literal /testbench/u_board/nf2_top/nf2_core/user_data_path/drop_nth_packet/pick_packet1_reg
add wave -noupdate -format Literal /testbench/u_board/nf2_top/nf2_core/user_data_path/drop_nth_packet/pick_packet2_reg
add wave -noupdate -format Literal /testbench/u_board/nf2_top/nf2_core/user_data_path/drop_nth_packet/pick_packet3_reg
add wave -noupdate -format Literal /testbench/u_board/nf2_top/nf2_core/user_data_path/drop_nth_packet/pick_packet4_reg
add wave -noupdate -format Literal /testbench/u_board/nf2_top/nf2_core/user_data_path/drop_nth_packet/pick_packet5_reg
add wave -noupdate -format Literal /testbench/u_board/nf2_top/nf2_core/user_data_path/drop_nth_packet/pick_packet6_reg
add wave -noupdate -format Literal /testbench/u_board/nf2_top/nf2_core/user_data_path/drop_nth_packet/pick_packet7_reg
add wave -noupdate -format Logic /testbench/u_board/nf2_top/nf2_core/user_data_path/drop_nth_packet/key
add wave -noupdate -format Logic /testbench/u_board/nf2_top/nf2_core/user_data_path/drop_nth_packet/module_regs/reg_req_in
add wave -noupdate -format Logic /testbench/u_board/nf2_top/nf2_core/user_data_path/drop_nth_packet/module_regs/reg_ack_in
add wave -noupdate -format Logic /testbench/u_board/nf2_top/nf2_core/user_data_path/drop_nth_packet/module_regs/reg_rd_wr_L_in
add wave -noupdate -format Literal /testbench/u_board/nf2_top/nf2_core/user_data_path/drop_nth_packet/module_regs/reg_addr_in
add wave -noupdate -format Literal /testbench/u_board/nf2_top/nf2_core/user_data_path/drop_nth_packet/module_regs/reg_data_in
add wave -noupdate -format Literal /testbench/u_board/nf2_top/nf2_core/user_data_path/drop_nth_packet/module_regs/reg_src_in
add wave -noupdate -format Logic /testbench/u_board/nf2_top/nf2_core/user_data_path/drop_nth_packet/module_regs/reg_req_out
add wave -noupdate -format Logic /testbench/u_board/nf2_top/nf2_core/user_data_path/drop_nth_packet/module_regs/reg_ack_out
add wave -noupdate -format Logic /testbench/u_board/nf2_top/nf2_core/user_data_path/drop_nth_packet/module_regs/reg_rd_wr_L_out
add wave -noupdate -format Literal /testbench/u_board/nf2_top/nf2_core/user_data_path/drop_nth_packet/module_regs/reg_addr_out
add wave -noupdate -format Literal /testbench/u_board/nf2_top/nf2_core/user_data_path/drop_nth_packet/module_regs/reg_data_out
add wave -noupdate -format Literal /testbench/u_board/nf2_top/nf2_core/user_data_path/drop_nth_packet/module_regs/reg_src_out
add wave -noupdate -format Logic /testbench/u_board/nf2_top/nf2_core/user_data_path/drop_nth_packet/module_regs/counter_updates
add wave -noupdate -format Logic /testbench/u_board/nf2_top/nf2_core/user_data_path/drop_nth_packet/module_regs/counter_decrement
add wave -noupdate -format Literal /testbench/u_board/nf2_top/nf2_core/user_data_path/drop_nth_packet/module_regs/software_regs
add wave -noupdate -format Literal /testbench/u_board/nf2_top/nf2_core/user_data_path/drop_nth_packet/module_regs/hardware_regs
add wave -noupdate -format Logic /testbench/u_board/nf2_top/nf2_core/user_data_path/drop_nth_packet/module_regs/clk
add wave -noupdate -format Logic /testbench/u_board/nf2_top/nf2_core/user_data_path/drop_nth_packet/module_regs/reset
add wave -noupdate -format Logic /testbench/u_board/nf2_top/nf2_core/user_data_path/drop_nth_packet/module_regs/cntr_reg_req_out
add wave -noupdate -format Logic /testbench/u_board/nf2_top/nf2_core/user_data_path/drop_nth_packet/module_regs/cntr_reg_ack_out
add wave -noupdate -format Logic /testbench/u_board/nf2_top/nf2_core/user_data_path/drop_nth_packet/module_regs/cntr_reg_rd_wr_L_out
add wave -noupdate -format Literal /testbench/u_board/nf2_top/nf2_core/user_data_path/drop_nth_packet/module_regs/cntr_reg_addr_out
add wave -noupdate -format Literal /testbench/u_board/nf2_top/nf2_core/user_data_path/drop_nth_packet/module_regs/cntr_reg_data_out
add wave -noupdate -format Literal /testbench/u_board/nf2_top/nf2_core/user_data_path/drop_nth_packet/module_regs/cntr_reg_src_out
add wave -noupdate -format Logic /testbench/u_board/nf2_top/nf2_core/user_data_path/drop_nth_packet/module_regs/sw_reg_req_out
add wave -noupdate -format Logic /testbench/u_board/nf2_top/nf2_core/user_data_path/drop_nth_packet/module_regs/sw_reg_ack_out
add wave -noupdate -format Logic /testbench/u_board/nf2_top/nf2_core/user_data_path/drop_nth_packet/module_regs/sw_reg_rd_wr_L_out
add wave -noupdate -format Literal /testbench/u_board/nf2_top/nf2_core/user_data_path/drop_nth_packet/module_regs/sw_reg_addr_out
add wave -noupdate -format Literal /testbench/u_board/nf2_top/nf2_core/user_data_path/drop_nth_packet/module_regs/sw_reg_data_out
add wave -noupdate -format Literal /testbench/u_board/nf2_top/nf2_core/user_data_path/drop_nth_packet/module_regs/sw_reg_src_out
add wave -noupdate -format Logic /testbench/u_board/nf2_top/nf2_core/user_data_path/drop_nth_packet/module_regs/hw_reg_req_out
add wave -noupdate -format Logic /testbench/u_board/nf2_top/nf2_core/user_data_path/drop_nth_packet/module_regs/hw_reg_ack_out
add wave -noupdate -format Logic /testbench/u_board/nf2_top/nf2_core/user_data_path/drop_nth_packet/module_regs/hw_reg_rd_wr_L_out
add wave -noupdate -format Literal /testbench/u_board/nf2_top/nf2_core/user_data_path/drop_nth_packet/module_regs/hw_reg_addr_out
add wave -noupdate -format Literal /testbench/u_board/nf2_top/nf2_core/user_data_path/drop_nth_packet/module_regs/hw_reg_data_out
add wave -noupdate -format Literal /testbench/u_board/nf2_top/nf2_core/user_data_path/drop_nth_packet/module_regs/hw_reg_src_out
add wave -noupdate -format Literal /testbench/u_board/nf2_top/nf2_core/user_data_path/drop_nth_packet/module_regs/reg_addr_in_swapped
add wave -noupdate -format Literal /testbench/u_board/nf2_top/nf2_core/user_data_path/drop_nth_packet/module_regs/hw_reg_addr_out_swapped
add wave -noupdate -format Logic /testbench/u_board/nf2_top/nf2_core/user_data_path/drop_nth_packet/module_regs/counter_updates_ordered
add wave -noupdate -format Logic /testbench/u_board/nf2_top/nf2_core/user_data_path/drop_nth_packet/module_regs/counter_decrement_ordered
add wave -noupdate -format Literal /testbench/u_board/nf2_top/nf2_core/user_data_path/drop_nth_packet/module_regs/software_regs_ordered
add wave -noupdate -format Literal /testbench/u_board/nf2_top/nf2_core/user_data_path/drop_nth_packet/module_regs/hardware_regs_ordered
add wave -noupdate -format Logic /testbench/u_board/nf2_top/nf2_core/user_data_path/drop_nth_packet/module_regs/counter_updates_expanded
add wave -noupdate -format Logic /testbench/u_board/nf2_top/nf2_core/user_data_path/drop_nth_packet/module_regs/counter_decrement_expanded
add wave -noupdate -format Literal /testbench/u_board/nf2_top/nf2_core/user_data_path/drop_nth_packet/module_regs/software_regs_expanded
add wave -noupdate -format Literal /testbench/u_board/nf2_top/nf2_core/user_data_path/drop_nth_packet/module_regs/hardware_regs_expanded
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {114164000 ps} 0}
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
configure wave -timelineunits ps
update
WaveRestoreZoom {114111698 ps} {114304165 ps}
