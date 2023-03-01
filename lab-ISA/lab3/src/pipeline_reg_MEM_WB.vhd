library ieee;
library work;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use work.my_pkg.all;

entity pipeline_reg_MEM_WB is 
port (

clk: in std_logic;
reset: in std_logic;
instruction_out_MEM: in std_logic_vector(31 downto 0);
ALU_result_out_MEM: in std_logic_vector(31 downto 0);
write_data_out_MEM: in std_logic_vector(31 downto 0);
address_RF: out std_logic_vector(4 downto 0);
ALU_result_in_WB: out std_logic_vector(31 downto 0);
write_data_in_WB: out std_logic_vector(31 downto 0)
);
end pipeline_reg_MEM_WB;


architecture Behavioral of pipeline_reg_MEM_WB is
signal address_RF_reg: std_logic_vector(4 downto 0);
signal ALU_result_out_MEM_reg: std_logic_vector(31 downto 0);
signal write_data_out_MEM_reg: std_logic_vector(31 downto 0);

begin
    process (clk, reset)
    begin
        if (reset = '1') then
            address_RF_reg <= (others => '0');
            ALU_result_out_MEM_reg <= (others => '0');
            write_data_out_MEM_reg <= (others => '0');
        elsif (clk'event and clk = '1') then
                address_RF_reg <= instruction_out_MEM(11 downto 7);
                ALU_result_out_MEM_reg <= ALU_result_out_MEM;
                write_data_out_MEM_reg <= write_data_out_MEM;
        end if;
    end process;

    address_RF <= address_RF_reg;
    ALU_result_in_WB <= ALU_result_out_MEM_reg;
    write_data_in_WB <= write_data_out_MEM_reg;
end Behavioral;
