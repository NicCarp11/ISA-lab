vcom -work ./work ../src/clk_gen.vhd
vcom -work ./work ../src/register.vhd
vcom -work ./work ../src/register_valid.vhd
vcom -work ./work ../src/data_maker_new_unfolded.vhd
vcom -work ./work ../src/data_sink_unfolded.vhd
vlog -work ./work ../innovus/myfilter.v
vlog -work ./work ../tb/tb_filter.v
vsim -L /eda/dk/nangate45/verilog/qsim2020.4 -sdfmax /tb_filter/UUT=../innovus/myfilter.sdf work.tb_filter
