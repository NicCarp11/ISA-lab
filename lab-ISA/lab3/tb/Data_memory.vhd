library ieee;
library work;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;
use work.my_pkg.all;

entity DMEM is
port(
Data_in_mem : in std_logic_vector(31 downto 0);
ADDRESS: in std_logic_vector (31 downto 0);
read_not_write: in std_logic;
CLK: in std_logic;
reset: in std_logic;
en: in std_logic;

Data_out_mem: out std_logic_vector(31 downto 0));
end DMEM;

architecture beh of DMEM is 

type Dmem_vec is array (13 downto 0) of std_logic_vector (31 downto 0);
signal Mem : Dmem_vec;
signal real_address: std_logic_vector (31 downto 0);



begin
real_address <= address ;--- "00010000000000010000000000000000";
process(CLK, reset) is
begin
if (reset = '1') then 
Mem <= ("00000000000000001111111111111111",
        "00000000000000001111111111111101",
        "00000000000000000000000000000000",
        "00000000000000000000000000011010",
        "00000000000000000000000000000000",
        "00000000000000000000000000001110",
        "00000000000000001111111111111111",
        "00000000000000001111111111111110",
        "00000000000000000000000000000000",
        "00000000000000000000000000010101",
        "00000000000000001111111111111111",
        "00000000000000001111111111010010",
        "00000000000000000000000000000000",
         "00000000000000000000000000001001"
);
else 
		if (en = '1') then
			if (read_not_write = '1') then 
				Data_out_mem <= Mem(conv_integer(unsigned(real_address(31 downto 2)))); --reading
			elsif (read_not_write = '0' and ( rising_edge(clk) )) then 
				Mem(conv_integer(unsigned(real_address(31 downto 2)))) <= Data_in_mem; --writing
			else 
				Data_out_mem <= (OTHERS=>'0');
end if;
end if;
end if;

end process;

end beh;



