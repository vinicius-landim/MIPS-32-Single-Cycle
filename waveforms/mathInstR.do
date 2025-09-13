onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -label clock /sim_mips_processor/clk
add wave -noupdate -label reset_pc /sim_mips_processor/reset_pc
add wave -noupdate -label switches -radix decimal /sim_mips_processor/switches
add wave -noupdate -label data_out -radix decimal /sim_mips_processor/data_out
add wave -noupdate -label {registers[1]} -radix decimal {/sim_mips_processor/dut/register_file/registers[1]}
add wave -noupdate -label {registers[2]} -radix decimal {/sim_mips_processor/dut/register_file/registers[2]}
add wave -noupdate -label {registers[3]} -radix decimal {/sim_mips_processor/dut/register_file/registers[3]}
add wave -noupdate -label instruction_code /sim_mips_processor/dut/instruction_memory/inst_code
add wave -noupdate -label pc_addr /sim_mips_processor/dut/pc_addr
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 154
configure wave -valuecolwidth 100
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
WaveRestoreZoom {0 ps} {68 ps}
