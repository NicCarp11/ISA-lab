library ieee;
library work;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.STD_LOGIC_UNSIGNED.all;
use ieee.numeric_std.all;
use work.my_pkg.all;

entity register_PC is
PORT(
    D: IN std_logic_vector(NBIT -1 downto 0);
    Q: OUT std_logic_vector(NBIT -1 downto 0);
    Clk, rst, en: IN std_logic);
end register_PC;

architecture beh of register_PC  is

begin
process(rst, clk, en)
begin
if (rst ='1') then
Q<=(others=>'0');
elsif (rising_edge (clk)) then
if (en = '0') then
Q<=D;
end if;
end if;
end process;

end beh;
