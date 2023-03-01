library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity reg_valid is
PORT(
    I: IN std_logic;
    Q: OUT std_logic;
    Clk, Rst, en: IN std_logic);
end reg_valid;

architecture Behavioral of reg_valid is

begin
process(rst, clk)
begin
if (rst ='0') then
Q<='0';
elsif (rising_edge (clk)) then
if (en = '1') then
Q<=I;
end if;
end if;
end process;

end Behavioral;
