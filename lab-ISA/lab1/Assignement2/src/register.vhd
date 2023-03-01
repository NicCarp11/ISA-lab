library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity reg is
PORT(
    I: IN std_logic_vector(9 downto 0);
    Q: OUT std_logic_vector(9 downto 0);
    Clk, Rst, en: IN std_logic);
end reg;

architecture Behavioral of reg is

begin
process(rst, clk)
begin
if (rst ='0') then
Q<=(others=>'0');
elsif (rising_edge (clk)) then
if (en = '1') then
Q<=I;
end if;
end if;
end process;

end Behavioral;
