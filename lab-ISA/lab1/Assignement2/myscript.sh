vcom -work ./work ../src/clk_gen.vhd
vcom -work ./work ../src/data_maker_new.vhd
vcom -work ./work ../src/data_sink.vhd
vcom -work ./work ../src/myfir.vhd
vcom -work ./work ../src/register.vhd
vcom -work ./work ../src/register_valid.vhd
vlog -work ./work ../tb/tb_fir.v
vsim work.tb_fir -voptargs=+acc.
