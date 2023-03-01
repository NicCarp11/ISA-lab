vcom -work ./work ../src/clk_gen.vhd
vcom -work ./work ../src/data_maker_new_unfolded.vhd
vcom -work ./work ../src/data_sink_unfolded.vhd
vcom -work ./work ../src/myfilter.vhd
vcom -work ./work ../src/register.vhd
vcom -work ./work ../src/register_valid.vhd
vlog -work ./work ../tb/tb_filter.v
vsim work.tb_filter -voptargs=+acc.
