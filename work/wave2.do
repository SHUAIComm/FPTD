onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb_ASIC2/Clock
add wave -noupdate /tb_ASIC2/nReset
add wave -noupdate /tb_ASIC2/but1
add wave -noupdate /tb_ASIC2/bua2
add wave -noupdate /tb_ASIC2/bua3
add wave -noupdate /tb_ASIC2/blt1
add wave -noupdate /tb_ASIC2/bla2
add wave -noupdate /tb_ASIC2/bla3
add wave -noupdate /tb_ASIC2/BusData
add wave -noupdate /tb_ASIC2/In
add wave -noupdate /tb_ASIC2/DOut1
add wave -noupdate /tb_ASIC2/TOut
add wave -noupdate /tb_ASIC2/Mode
add wave -noupdate /tb_ASIC2/Enable_f
add wave -noupdate /tb_ASIC2/Sel_f
add wave -noupdate /tb_ASIC2/S1
add wave -noupdate /tb_ASIC2/S2
add wave -noupdate /tb_ASIC2/S3
add wave -noupdate /tb_ASIC2/Dclk
add wave -noupdate /tb_ASIC2/Go
add wave -noupdate /tb_ASIC2/bitout1
add wave -noupdate /tb_ASIC2/bitout2
add wave -noupdate /tb_ASIC2/KeepShift
add wave -noupdate /tb_ASIC2/Start
add wave -noupdate /tb_ASIC2/Start2
add wave -noupdate /tb_ASIC2/b1_MATLAB
add wave -noupdate /tb_ASIC2/TestReady
add wave -noupdate /tb_ASIC2/ASIC1/SysControl1/state1
add wave -noupdate /tb_ASIC2/ASIC1/SysControl1/state
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {22050000 ps} 0}
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
WaveRestoreZoom {1886228 ps} {58892216 ps}
