library ieee;
library work;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use work.my_pkg.all;

entity pipeline_reg_EX_MEM is 
port (
    clk: in std_logic;
    reset: in std_logic;
    out_ALU_or_address_MEM: in std_logic_vector(31 downto 0);
    inst_type_out_EX: in Instruction;
    instruction_out_EX: in std_logic_vector(31 downto 0);
    data_write_out_EX: in std_logic_vector(31 downto 0); --coming from pipeline ID/EX
    ALU_or_address_MEM_in: out std_logic_vector(31 downto 0);
    inst_type_in_MEM: out Instruction;
    instruction_in_MEM: out std_logic_vector(31 downto 0);
    data_write_in_MEM: out std_logic_vector(31 downto 0)
    );
end pipeline_reg_EX_MEM;

architecture Behavioral of pipeline_reg_EX_MEM is
    signal ALU_or_address_MEM: std_logic_vector(31 downto 0);
    signal inst_type_EX_MEM: Instruction;
    signal instruction_EX_MEM: std_logic_vector(31 downto 0);
    signal data_write_EX_MEM: std_logic_vector(31 downto 0);
begin
    process(clk, reset)
    begin
        if reset = '1' then
            ALU_or_address_MEM <= (others => '0');
            inst_type_EX_MEM <= LUI;
            instruction_EX_MEM <="00000000000000000000000000110111";
            data_write_EX_MEM <= (others => '0');
        elsif rising_edge(clk) then
                ALU_or_address_MEM <= out_ALU_or_address_MEM;
                inst_type_EX_MEM <= inst_type_out_EX;
                instruction_EX_MEM <= instruction_out_EX;
                data_write_EX_MEM <= data_write_out_EX;  
           
        end if;
    end process;
    
    ALU_or_address_MEM_in <= ALU_or_address_MEM;
    inst_type_in_MEM <= inst_type_EX_MEM;
    instruction_in_MEM <= instruction_EX_MEM;
    data_write_in_MEM <= data_write_EX_MEM;
end Behavioral;