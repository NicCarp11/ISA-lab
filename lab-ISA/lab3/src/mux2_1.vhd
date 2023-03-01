library ieee;
library work;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use work.my_pkg.all;

entity mux2_1 is
	port(
		IN0_mux : in std_logic_vector(NBIT -1 downto 0);
		IN1_mux : in std_logic_vector(NBIT -1 downto 0);
		sel_mux : in std_logic;
		out_mux : out std_logic_vector(NBIT -1 downto 0));
end mux2_1;

architecture beh of mux2_1 is
begin

out_mux <= IN0_mux when sel_mux = '0' else
 IN1_mux when sel_mux = '1' else
(others => '0');

end beh;