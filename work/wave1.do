onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb_ASIC1/Clock
add wave -noupdate /tb_ASIC1/nReset
add wave -noupdate /tb_ASIC1/BusData
add wave -noupdate /tb_ASIC1/In
add wave -noupdate -radix unsigned /tb_ASIC1/DOut1
add wave -noupdate /tb_ASIC1/TOut
add wave -noupdate /tb_ASIC1/Mode
add wave -noupdate /tb_ASIC1/Enable_f
add wave -noupdate /tb_ASIC1/Sel_f
add wave -noupdate /tb_ASIC1/S1
add wave -noupdate /tb_ASIC1/S2
add wave -noupdate /tb_ASIC1/S3
add wave -noupdate /tb_ASIC1/TestReady
add wave -noupdate /tb_ASIC1/Go
add wave -noupdate /tb_ASIC1/bitout1
add wave -noupdate /tb_ASIC1/KeepShift
add wave -noupdate /tb_ASIC1/Start
add wave -noupdate /tb_ASIC1/b1_MATLAB
add wave -noupdate /tb_ASIC1/Start2
add wave -noupdate /tb_ASIC1/data
add wave -noupdate /tb_ASIC1/DCs
add wave -noupdate /tb_ASIC1/errors
add wave -noupdate /tb_ASIC1/i
add wave -noupdate /tb_ASIC1/j
add wave -noupdate /tb_ASIC1/finished1
add wave -noupdate /tb_ASIC1/finished2
add wave -noupdate /tb_ASIC1/ASIC1/SysControl1/state
add wave -noupdate /tb_ASIC1/ASIC1/SysControl1/state1
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {61750000 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
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
WaveRestoreZoom {30451065 ps} {63564837 ps}
