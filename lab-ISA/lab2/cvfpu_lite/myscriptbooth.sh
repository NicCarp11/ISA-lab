vlog -work ./work ../src/half_adder.sv
vlog -work ./work ../src/full_adder.sv
vlog -work ./work ../src/compressor_4_2.sv
vlog -work ./work ../src/fpnew_pkg.sv
vlog -work ./work ../src/booth_mul.sv
vcom -work ./work ../src/clk_gen.vhd
vlog -work ./work ../tb/tb_booth_mul.sv
vsim work.tb_booth_mul -voptargs=+acc.
