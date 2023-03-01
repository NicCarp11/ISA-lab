library ieee;
library work;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use work.my_pkg.all;

entity control_unit is 
port(
    clk: in std_logic;
    reset: in std_logic;
    stall: in std_logic;
    INST_TYPE: in Instruction;

    sel_mul_A_PC: out std_logic;
    sel_mul_B_imm: out std_logic;
    enable_MEM: out std_logic;
    R_not_W_Mem: out std_logic;
    Mem_not_ALU: out std_logic;
    R_not_W_Reg: out std_logic;
    ALU_op: out Instruction
    
    
); end control_unit;

architecture Behavioral of control_unit is
    signal CW: std_logic_vector(5 downto 0);
    signal CW_EX: std_logic_vector(5 downto 0);
    signal CW_MEM: std_logic_vector(3 downto 0);
    signal CW_WB: std_logic_vector(1 downto 0);
    signal ALU_op_EX: Instruction;

    begin
        CW <= "000000" when STALL = '1' else 
        "110000" WHEN INST_TYPE = AUIPC else
        "010000" WHEN INST_TYPE = ADDI else
        "000000" WHEN INST_TYPE = ADD else
        "100000" WHEN INST_TYPE = JAL else
        "010001" WHEN INST_TYPE = RET else
        "010000" when INST_TYPE = LUI else
        "011001" when INST_TYPE = SW else
        "011110" when INST_TYPE = LW else
        "010000" when INST_TYPE = SRAI else
        "000000" when INST_TYPE = XOR_op else
        "000000" when INST_TYPE = SUB else
        "010000" when INST_TYPE = SLLI else
        "000000";
  --fare il caso della STALL
        Alu_op_Ex <= LUI when STALL = '1' else 
        AUIPC when INST_TYPE = AUIPC else 
        ADDI when INST_TYPE = ADDI else
        ADD when INST_TYPE = ADD else
        JAL when INST_TYPE = JAL else
        RET when INST_TYPE = RET else
        LUI when INST_TYPE = LUI else
        SW when INST_TYPE = SW else
        LW when INST_TYPE = LW else
        SRAI when INST_TYPE = SRAI else
        XOR_op when INST_TYPE = XOR_op else
        SUB when INST_TYPE = SUB else
        SLLI when INST_TYPE = SLLI else
        LUI;


    CW_PROC: process(clk, reset) 
    begin
        if reset = '1' then 
            CW_EX <= "000000";
            CW_MEM <= "0000";
            CW_WB <= "00";
        elsif rising_edge(clk) then
            CW_EX <= CW;
            CW_MEM <= CW_EX(3 DOWNTO 0);
            CW_WB <= CW_MEM(1 DOWNTO 0);
            ALU_op <= ALU_op_EX;
        end if;

    end process CW_PROC;

    sel_MUL_A_PC <= CW_EX(5);
    sel_MUL_B_imm <= CW_EX(4);
    enable_MEM <= CW_MEM(3);
    R_not_W_Mem <= CW_MEM(2);
    R_not_W_Reg <= CW_WB(1);
    Mem_not_ALU <= CW_WB(0);
   
            
end Behavioral;
        
       
