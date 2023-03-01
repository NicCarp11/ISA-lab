library ieee;
library work;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use work.my_pkg.all;

ENTITY pipeline_reg_ID_EX is
port(
    clk: in std_logic;
    reset: in std_logic;
    stall : in std_logic;
    A_out_ID: in std_logic_vector(31 downto 0);
    B_out_ID: in std_logic_vector(31 downto 0);
    imm_out_ID: in std_logic_vector(31 downto 0);
    PC_out_ID: in std_logic_vector(31 downto 0);
    instruction_out_ID: in std_logic_vector(31 downto 0);
    inst_type_out_ID: in Instruction;
    A_in_EX: out std_logic_vector(31 downto 0);
    B_in_EX: out std_logic_vector(31 downto 0);
    imm_in_EX: out std_logic_vector(31 downto 0);
    PC_in_EX: out std_logic_vector(31 downto 0);
    instruction_in_EX: out std_logic_vector(31 downto 0);
    data_write_mem: out std_logic_vector(31 downto 0);
    inst_type_in_EX: out Instruction
    );
end pipeline_reg_ID_EX;

ARCHITECTURE arch of pipeline_reg_ID_EX is
    signal A_out_ID_reg: std_logic_vector(31 downto 0);
    signal B_out_ID_reg: std_logic_vector(31 downto 0);
    signal imm_out_ID_reg: std_logic_vector(31 downto 0);
    signal PC_out_ID_reg: std_logic_vector(31 downto 0);
    signal instruction_out_ID_reg: std_logic_vector(31 downto 0);
    signal data_write_mem_reg: std_logic_vector(31 downto 0);
    signal inst_type_out_ID_reg: Instruction;
begin
    process(clk, reset, stall)
    begin
        if (reset = '1') then 
            A_out_ID_reg <= (others => '0');
            B_out_ID_reg <= (others => '0');
            imm_out_ID_reg <= (others => '0');
            data_write_mem_reg <= (others => '0');
            PC_out_ID_reg <= (others => '0');
            instruction_out_ID_reg <= "00000000000000000000000000110111";
            inst_type_out_ID_reg <= LUI;
        elsif (rising_edge(clk) and stall = '0') then
                A_out_ID_reg <= A_out_ID;
                B_out_ID_reg <= B_out_ID;
                imm_out_ID_reg <= imm_out_ID;
                PC_out_ID_reg <= PC_out_ID;
                instruction_out_ID_reg <= instruction_out_ID;
                inst_type_out_ID_reg <= inst_type_out_ID;
                data_write_mem_reg <= B_out_ID;
          elsif (rising_edge(clk) and stall = '1') then--stall
            A_out_ID_reg <= (others => '0');
            B_out_ID_reg <= (others => '0');
            imm_out_ID_reg <= (others => '0');
            data_write_mem_reg <= (others => '0');
            PC_out_ID_reg <= (others => '0');
            instruction_out_ID_reg <= "00000000000000000000000000110111";
            inst_type_out_ID_reg <= LUI;
            
            end if;
   
    end process;
    A_in_EX <= A_out_ID_reg;
    B_in_EX <= B_out_ID_reg;
    imm_in_EX <= imm_out_ID_reg;
    PC_in_EX <= PC_out_ID_reg;
    data_write_mem <= data_write_mem_reg;
    instruction_in_EX <= instruction_out_ID_reg;
    inst_type_in_EX <= inst_type_out_ID_reg;
end arch;
