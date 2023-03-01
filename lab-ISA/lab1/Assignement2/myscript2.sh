vcom -work ./work ../src/clk_gen.vhd
vcom -work ./work ../src/register.vhd
vcom -work ./work ../src/register_valid.vhd
vcom -work ./work ../src/data_maker_new.vhd
vcom -work ./work ../src/data_sink.vhd
vlog -work ./work ../netlist/myfir.v
vlog -work ./work ../tb/tb_fir.v
vsim -L /eda/dk/nangate45/verilog/qsim2020.4 -sdftyp /tb_fir/UUT=../netlist/myfir.sdf work.tb_fir
