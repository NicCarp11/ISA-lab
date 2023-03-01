vlog -work ./work ../src/cf_math_pkg.sv
vlog -work ./work ../src/lzc.sv
vlog -work ./work ../src/rr_arb_tree.sv
vlog -work ./work ../src/fpnew_pkg.sv
vlog -work ./work ../src/fpnew_classifier.sv
vlog -work ./work ../src/fpnew_rounding.sv
vlog -work ./work ../src/half_adder.sv
vlog -work ./work ../src/full_adder.sv
vlog -work ./work ../src/compressor_4_2.sv
vlog -work ./work ../src/booth_mul.sv
vlog -work ./work ../src/fpnew_fma.sv
vlog -work ./work ../src/fpnew_opgroup_fmt_slice.sv
vlog -work ./work ../src/fpnew_opgroup_block.sv
vlog -work ./work ../src/fpnew_top.sv

vcom -work ./work ../tb/clk_gen.vhd
vcom -work ./work ../tb/data_gen.vhd
vlog -work ./work ../tb/tb_fpnew_top_rtl.sv
vsim work.tb_fpnew_top -voptargs=+acc.
