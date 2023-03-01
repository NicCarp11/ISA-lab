library ieee;
library work;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use work.my_pkg.all;

entity tb_RISC is
end tb_RISC;

architecture struct of tb_RISC is
component RISC 
    PORT (
        CLK: in std_logic;
        RESET: in std_logic;
        data_in_mem : out std_logic_vector(31 downto 0);
        address_mem_or_ALU_result: inout std_logic_vector(31 downto 0);
        mem_en: out std_logic;
        data_out_mem: in std_logic_vector(31 downto 0);
        read_not_write: out std_logic;
        PC_for_iMem: inout std_logic_vector(31 downto 0);
        INSTRUCTION_OUT_IMEM: in std_logic_vector(31 downto 0));

end component;

component IMEM 
port (
reset: in std_logic;
PC_IN : in std_logic_vector (31 downto 0);
INSTRUCTION_IMEM: out std_logic_vector (31 downto 0));
end component;



component DMEM 
port(
Data_in_mem : in std_logic_vector(31 downto 0);
ADDRESS: in std_logic_vector (31 downto 0);
read_not_write: in std_logic;
CLK: in std_logic;
reset: in std_logic;
en: in std_logic;

Data_out_mem: out std_logic_vector(31 downto 0));
end component;

signal CLK_i : std_logic := '0';
signal RST_i : std_logic;
signal PC_i: std_logic_vector (31 downto 0);
signal instruction_i: std_logic_vector (31 downto 0);
signal data_mem_from_RISC: std_logic_vector (31 downto 0);
signal address_from_RISC: std_logic_vector (31 downto 0);
signal R_N_W_from_RISC: std_logic;
signal EN_from_RISC: std_logic;
signal Data_out_Mem_in_RISC: std_logic_vector(31 downto 0);


constant Ts : time := 1 ns;


begin
Rst_i <='1', '0' after 5 ns;

clk_gen:  process
  begin  -- process

      CLK_i <= not(CLK_i);
  
    wait for 0.5 ns;
  end process;


Instruction_mem: IMEM port map (
reset=> Rst_i,
PC_IN => PC_i,
INSTRUCTION_IMEM => instruction_i);


Data_mem: DMEM port map(
Data_in_mem => data_mem_from_RISC,
ADDRESS => address_from_RISC,
read_not_write => R_N_W_from_RISC,
CLK => CLK_i,
reset => rst_i,
en => EN_from_RISC,
Data_out_mem => Data_out_Mem_in_RISC);

Risc_V: Risc port map (

        CLK => clk_i,
        RESET => rst_i,
        data_in_mem => data_mem_from_RISC,
        address_mem_or_ALU_result => address_from_RISC,
        mem_en => EN_from_RISC,
        data_out_mem => Data_out_Mem_in_RISC,
        read_not_write => R_N_W_from_RISC,
        PC_for_iMem => PC_i,
        INSTRUCTION_OUT_IMEM => instruction_i);

end struct;
