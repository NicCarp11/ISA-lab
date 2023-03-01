library ieee;
library work;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use work.my_pkg.all;

ENTITY pipeline_reg_IF_ID is
port(
    CLK: in std_logic;
    reset: in std_logic;
    PC_out_fetch: in std_logic_vector(31 downto 0);
    is_branch_taken_ID: in std_logic;
    instruction_out_fetch: in std_logic_vector(31 downto 0);
    INST_TYPE_out_fetch: in Instruction;
    PC_in_decode: out std_logic_vector(31 downto 0);
    instruction_in_decode: out std_logic_vector(31 downto 0);
    INST_TYPE_in_decode: out Instruction
    );
end pipeline_reg_IF_ID;

ARCHITECTURE arch of pipeline_reg_IF_ID is
    signal PC_out_fetch_reg: std_logic_vector(31 downto 0);
    signal instruction_out_fetch_reg: std_logic_vector(31 downto 0);
    signal INST_TYPE_out_fetch_reg : Instruction;
begin
    process(CLK, reset, is_branch_taken_ID)
    begin
        if reset = '1' then
            PC_out_fetch_reg <= (others => '0');
            instruction_out_fetch_reg <= "00000000000000000000000000110111"; 
            INST_TYPE_out_fetch_reg <= LUI ;
        elsif rising_edge(CLK) then
        if is_branch_taken_ID = '1' then
            PC_out_fetch_reg <= (others => '0');
            instruction_out_fetch_reg <="00000000000000000000000000110111"; 
            INST_TYPE_out_fetch_reg <= LUI;
        else
        PC_out_fetch_reg <= PC_out_fetch;
        instruction_out_fetch_reg <= instruction_out_fetch;
        INST_TYPE_out_fetch_reg <= INST_TYPE_out_fetch;
            end if;
        end if;
    end process;
    PC_in_decode <= PC_out_fetch_reg;
    instruction_in_decode <= instruction_out_fetch_reg;
    INST_TYPE_in_decode <= INST_TYPE_out_fetch_reg;
end arch;
