onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb_avalon_ASIC/clk
add wave -noupdate -expand -subitemconfig {/tb_avalon_ASIC/avalon_st.SRC {-height 15 -childformat {{/tb_avalon_ASIC/avalon_st.SRC.data -radix hexadecimal}}} /tb_avalon_ASIC/avalon_st.SRC.data {-height 15 -radix hexadecimal}} /tb_avalon_ASIC/avalon_st
add wave -noupdate -radix unsigned /tb_avalon_ASIC/data_count
add wave -noupdate /tb_avalon_ASIC/u_bfm/sc_fifo_1/out_ready
add wave -noupdate /tb_avalon_ASIC/u_bfm/sc_fifo_0/in_data
add wave -noupdate /tb_avalon_ASIC/u_bfm/sc_fifo_0/out_data
add wave -noupdate /tb_avalon_ASIC/start
add wave -noupdate /tb_avalon_ASIC/keepshift
add wave -noupdate -radix unsigned /tb_avalon_ASIC/error
add wave -noupdate /tb_avalon_ASIC/bitout
add wave -noupdate -radix unsigned /tb_avalon_ASIC/error_count
add wave -noupdate -radix unsigned /tb_avalon_ASIC/u_bfm/asic_avalon_0/DC
add wave -noupdate -radix unsigned /tb_avalon_ASIC/u_bfm/asic_avalon_0/DC_mode_1
add wave -noupdate /tb_avalon_ASIC/u_bfm/asic_avalon_0/Start
add wave -noupdate /tb_avalon_ASIC/u_bfm/asic_avalon_0/u_ASIC/In
add wave -noupdate /tb_avalon_ASIC/u_bfm/asic_avalon_0/Go
add wave -noupdate /tb_avalon_ASIC/u_bfm/asic_avalon_0/sink_sop
add wave -noupdate /tb_avalon_ASIC/u_bfm/asic_avalon_0/sink_eop
add wave -noupdate /tb_avalon_ASIC/u_bfm/asic_avalon_0/sink_valid
add wave -noupdate /tb_avalon_ASIC/u_bfm/asic_avalon_0/sink_ready
add wave -noupdate /tb_avalon_ASIC/u_bfm/asic_avalon_0/source_sop
add wave -noupdate /tb_avalon_ASIC/u_bfm/asic_avalon_0/source_eop
add wave -noupdate /tb_avalon_ASIC/u_bfm/asic_avalon_0/source_ready
add wave -noupdate /tb_avalon_ASIC/u_bfm/asic_avalon_0/source_valid
add wave -noupdate /tb_avalon_ASIC/u_bfm/asic_avalon_0/u_ASIC/SysControl1/state
add wave -noupdate /tb_avalon_ASIC/u_bfm/asic_avalon_0/u_ASIC/SysControl1/state1
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {42947561 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 375
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
configure wave -timelineunits us
update
WaveRestoreZoom {0 ps} {63 us}
