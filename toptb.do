onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /lab7_top_tb/KEY
add wave -noupdate /lab7_top_tb/DUT/MEM/mem
add wave -noupdate -group cpu /lab7_top_tb/DUT/CPU/clk
add wave -noupdate -group cpu /lab7_top_tb/DUT/CPU/reset
add wave -noupdate -group cpu /lab7_top_tb/DUT/CPU/read_data
add wave -noupdate -group cpu /lab7_top_tb/DUT/CPU/write_data
add wave -noupdate -group cpu /lab7_top_tb/DUT/CPU/mem_addr
add wave -noupdate -group cpu /lab7_top_tb/DUT/CPU/mem_cmd
add wave -noupdate -group cpu /lab7_top_tb/DUT/CPU/readAndwrite
add wave -noupdate -group cpu /lab7_top_tb/DUT/CPU/opcode
add wave -noupdate -group cpu /lab7_top_tb/DUT/CPU/shift
add wave -noupdate -group cpu /lab7_top_tb/DUT/CPU/op
add wave -noupdate -group cpu /lab7_top_tb/DUT/CPU/sximm8
add wave -noupdate -group cpu /lab7_top_tb/DUT/CPU/sximm5
add wave -noupdate -group cpu /lab7_top_tb/DUT/CPU/FSM_out
add wave -noupdate -group cpu /lab7_top_tb/DUT/CPU/Ireg_out
add wave -noupdate -group cpu /lab7_top_tb/DUT/CPU/dataAddress
add wave -noupdate -group cpu /lab7_top_tb/DUT/CPU/load_pc
add wave -noupdate -group cpu /lab7_top_tb/DUT/CPU/load_addr
add wave -noupdate -group cpu /lab7_top_tb/DUT/CPU/load_ir
add wave -noupdate -group cpu /lab7_top_tb/DUT/CPU/reset_pc
add wave -noupdate -group cpu /lab7_top_tb/DUT/CPU/addr_sel
add wave -noupdate -group cpu /lab7_top_tb/DUT/CPU/next_pc
add wave -noupdate -group cpu /lab7_top_tb/DUT/CPU/PC
add wave -noupdate -group cpu /lab7_top_tb/DUT/CPU/intoOne
add wave -noupdate -group cpu /lab7_top_tb/DUT/CPU/afterDataAddress
add wave -noupdate -group regfile /lab7_top_tb/DUT/CPU/DP/REGFILE/R0
add wave -noupdate -group regfile /lab7_top_tb/DUT/CPU/DP/REGFILE/R1
add wave -noupdate -group regfile /lab7_top_tb/DUT/CPU/DP/REGFILE/R2
add wave -noupdate -group regfile /lab7_top_tb/DUT/CPU/DP/REGFILE/R3
add wave -noupdate -group regfile /lab7_top_tb/DUT/CPU/DP/REGFILE/R4
add wave -noupdate -group regfile /lab7_top_tb/DUT/CPU/DP/REGFILE/R5
add wave -noupdate -group regfile /lab7_top_tb/DUT/CPU/DP/REGFILE/R6
add wave -noupdate -group regfile /lab7_top_tb/DUT/CPU/DP/REGFILE/R7
add wave -noupdate -group lab7_top /lab7_top_tb/DUT/KEY
add wave -noupdate -group lab7_top /lab7_top_tb/DUT/SW
add wave -noupdate -group lab7_top -expand /lab7_top_tb/DUT/LEDR
add wave -noupdate -group lab7_top /lab7_top_tb/DUT/HEX0
add wave -noupdate -group lab7_top /lab7_top_tb/DUT/HEX1
add wave -noupdate -group lab7_top /lab7_top_tb/DUT/HEX2
add wave -noupdate -group lab7_top /lab7_top_tb/DUT/HEX3
add wave -noupdate -group lab7_top /lab7_top_tb/DUT/HEX4
add wave -noupdate -group lab7_top /lab7_top_tb/DUT/HEX5
add wave -noupdate -group lab7_top /lab7_top_tb/DUT/mem_addr
add wave -noupdate -group lab7_top /lab7_top_tb/DUT/mem_cmd
add wave -noupdate -group lab7_top /lab7_top_tb/DUT/read_data
add wave -noupdate -group lab7_top /lab7_top_tb/DUT/write_data
add wave -noupdate -group lab7_top /lab7_top_tb/DUT/dout
add wave -noupdate -group lab7_top /lab7_top_tb/DUT/msel
add wave -noupdate -group lab7_top /lab7_top_tb/DUT/mread
add wave -noupdate -group lab7_top /lab7_top_tb/DUT/doutToggle
add wave -noupdate -group lab7_top /lab7_top_tb/DUT/write
add wave -noupdate -group lab7_top /lab7_top_tb/DUT/mwrite
add wave -noupdate -group lab7_top /lab7_top_tb/DUT/Z
add wave -noupdate -group lab7_top /lab7_top_tb/DUT/N
add wave -noupdate -group lab7_top /lab7_top_tb/DUT/V
add wave -noupdate -group lab7_top /lab7_top_tb/DUT/reset
add wave -noupdate -group lab7_top /lab7_top_tb/DUT/clk
add wave -noupdate -group stateMachine /lab7_top_tb/DUT/CPU/stateMachine/clk
add wave -noupdate -group stateMachine /lab7_top_tb/DUT/CPU/stateMachine/opcode
add wave -noupdate -group stateMachine /lab7_top_tb/DUT/CPU/stateMachine/op
add wave -noupdate -group stateMachine /lab7_top_tb/DUT/CPU/stateMachine/reset
add wave -noupdate -group stateMachine /lab7_top_tb/DUT/CPU/stateMachine/out
add wave -noupdate -group stateMachine /lab7_top_tb/DUT/CPU/stateMachine/addr_sel
add wave -noupdate -group stateMachine /lab7_top_tb/DUT/CPU/stateMachine/load_pc
add wave -noupdate -group stateMachine /lab7_top_tb/DUT/CPU/stateMachine/reset_pc
add wave -noupdate -group stateMachine /lab7_top_tb/DUT/CPU/stateMachine/load_addr
add wave -noupdate -group stateMachine /lab7_top_tb/DUT/CPU/stateMachine/load_ir
add wave -noupdate -group stateMachine /lab7_top_tb/DUT/CPU/stateMachine/mem_cmd
add wave -noupdate -group stateMachine /lab7_top_tb/DUT/CPU/stateMachine/state
add wave -noupdate -group {Instruction Decoder} /lab7_top_tb/DUT/CPU/ID1/in
add wave -noupdate -group {Instruction Decoder} /lab7_top_tb/DUT/CPU/ID1/nsel
add wave -noupdate -group {Instruction Decoder} /lab7_top_tb/DUT/CPU/ID1/op
add wave -noupdate -group {Instruction Decoder} /lab7_top_tb/DUT/CPU/ID1/shift
add wave -noupdate -group {Instruction Decoder} /lab7_top_tb/DUT/CPU/ID1/opcode
add wave -noupdate -group {Instruction Decoder} /lab7_top_tb/DUT/CPU/ID1/sximm8
add wave -noupdate -group {Instruction Decoder} /lab7_top_tb/DUT/CPU/ID1/sximm5
add wave -noupdate -group {Instruction Decoder} /lab7_top_tb/DUT/CPU/ID1/readOrWrite
add wave -noupdate -group {Instruction Decoder} /lab7_top_tb/DUT/CPU/ID1/rORw
add wave -noupdate -group DP /lab7_top_tb/DUT/CPU/DP/clk
add wave -noupdate -group DP /lab7_top_tb/DUT/CPU/DP/write
add wave -noupdate -group DP /lab7_top_tb/DUT/CPU/DP/asel
add wave -noupdate -group DP /lab7_top_tb/DUT/CPU/DP/bsel
add wave -noupdate -group DP /lab7_top_tb/DUT/CPU/DP/loadc
add wave -noupdate -group DP /lab7_top_tb/DUT/CPU/DP/loads
add wave -noupdate -group DP /lab7_top_tb/DUT/CPU/DP/loada
add wave -noupdate -group DP /lab7_top_tb/DUT/CPU/DP/loadb
add wave -noupdate -group DP /lab7_top_tb/DUT/CPU/DP/writenum
add wave -noupdate -group DP /lab7_top_tb/DUT/CPU/DP/readnum
add wave -noupdate -group DP /lab7_top_tb/DUT/CPU/DP/shift
add wave -noupdate -group DP /lab7_top_tb/DUT/CPU/DP/ALUop
add wave -noupdate -group DP /lab7_top_tb/DUT/CPU/DP/vsel
add wave -noupdate -group DP /lab7_top_tb/DUT/CPU/DP/mdata
add wave -noupdate -group DP /lab7_top_tb/DUT/CPU/DP/sximm8
add wave -noupdate -group DP /lab7_top_tb/DUT/CPU/DP/sximm5
add wave -noupdate -group DP /lab7_top_tb/DUT/CPU/DP/PC
add wave -noupdate -group DP /lab7_top_tb/DUT/CPU/DP/data_in
add wave -noupdate -group DP /lab7_top_tb/DUT/CPU/DP/data_out
add wave -noupdate -group DP /lab7_top_tb/DUT/CPU/DP/in
add wave -noupdate -group DP /lab7_top_tb/DUT/CPU/DP/sout
add wave -noupdate -group DP /lab7_top_tb/DUT/CPU/DP/Ain
add wave -noupdate -group DP /lab7_top_tb/DUT/CPU/DP/Bin
add wave -noupdate -group DP /lab7_top_tb/DUT/CPU/DP/out
add wave -noupdate -group DP /lab7_top_tb/DUT/CPU/DP/A2MUX
add wave -noupdate -group DP /lab7_top_tb/DUT/CPU/DP/Z_internal
add wave -noupdate -group DP /lab7_top_tb/DUT/CPU/DP/datapath_out
add wave -noupdate -group DP /lab7_top_tb/DUT/CPU/DP/N
add wave -noupdate -group DP /lab7_top_tb/DUT/CPU/DP/V
add wave -noupdate -group DP /lab7_top_tb/DUT/CPU/DP/Z
add wave -noupdate -group DP /lab7_top_tb/DUT/CPU/DP/Z_out
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {507 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 218
configure wave -valuecolwidth 126
configure wave -justifyvalue left
configure wave -signalnamewidth 0
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
WaveRestoreZoom {456 ps} {629 ps}
