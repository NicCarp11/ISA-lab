library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use work.my_pkg.all;

entity Shifter_Left1 is
	port(
		A : in std_logic_vector(NBIT - 1 downto 0); 
		OUT_sl : out std_logic_vector(NBIT - 1 downto 0)); 
end Shifter_Left1;

architecture beh of Shifter_Left1 is

begin
	
	P: process(A)
	variable A_shifted : std_logic_vector(NBIT - 1 downto 0);
	begin  
	       A_shifted := A;
			A_shifted := A_shifted(NBIT - 2 downto 0) & '0';
		
	OUT_sl <= A_shifted;
	end process;
	
end beh;
