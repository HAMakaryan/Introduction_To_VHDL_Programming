onerror {resume}
radix define I2C_CMD {
    "3'b000" "START_CMD" -color "#F1F10B",
    "3'b001" "WR_CMD" -color "#89F10B",
    "3'b010" "RD_CMD" -color "#0BF1CB",
    "3'b011" "STOP_CMD" -color "#0B93F1",
    "3'b100" "RESTART_CMD" -color "#F7DC6F",
    -default hexadecimal
}
quietly WaveActivateNextPane {} 0
add wave -noupdate /i2c_master_tb/clk
add wave -noupdate /i2c_master_tb/reset
add wave -noupdate /i2c_master_tb/din
add wave -noupdate -radix I2C_CMD /i2c_master_tb/cmd
add wave -noupdate -radix decimal /i2c_master_tb/dvsr
add wave -noupdate /i2c_master_tb/wr_i2c
add wave -noupdate /i2c_master_tb/scl
add wave -noupdate /i2c_master_tb/sda
add wave -noupdate /i2c_master_tb/ready
add wave -noupdate /i2c_master_tb/done_tick
add wave -noupdate /i2c_master_tb/ack
add wave -noupdate /i2c_master_tb/dout
add wave -noupdate /i2c_master_tb/end_of_test
add wave -noupdate /i2c_master_tb/DUT/state_reg
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {9995 ns} 0}
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
WaveRestoreZoom {0 ns} {22397 ns}
