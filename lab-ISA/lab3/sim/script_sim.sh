vcom -work ./work ../src/my_pkg.vhd
vcom -work ./work ../src/mux2_1.vhd
vcom -work ./work ../src/register.vhd
vcom -work ./work ../src/Shifter_Left.vhd
vcom -work ./work ../src/Shifter_Left1.vhd
vcom -work ./work ../src/Shifter_Right.vhd
vcom -work ./work ../src/register_file.vhd
vcom -work ./work ../src/ALU.vhd
vcom -work ./work ../src/BRANCH_JUMP_RET_DETECTION.vhd
vcom -work ./work ../src/immediate_generation.vhd
vcom -work ./work ../src/Instruction_Encoder.vhd
vcom -work ./work ../src/FETCH.vhd
vcom -work ./work ../src/decode_stage.vhd
vcom -work ./work ../src/EXECUTE.vhd
vcom -work ./work ../src/pipeline_reg_IF_ID.vhd
vcom -work ./work ../src/pipeline_reg_ID_EX.vhd
vcom -work ./work ../src/pipeline_reg_EX_MEM.vhd
vcom -work ./work ../src/pipeline_reg_MEM_WB.vhd
vcom -work ./work ../src/Hazard_detection_Unit.vhd
vcom -work ./work ../src/control_unit.vhd
vcom -work ./work ../src/riscV.vhd
vcom -work ./work ../tb/Instruction_memory.vhd
vcom -work ./work ../tb/Data_memory.vhd
vcom -work ./work ../tb/tb_RISC.vhd
vsim work.tb_RISC -voptargs=+acc.

