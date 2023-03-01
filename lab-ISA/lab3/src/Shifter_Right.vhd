library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use work.my_pkg.all; 

entity Shifter_Right is
	port(
		A : in std_logic_vector(NBIT - 1 downto 0); 
		Shift_Amount : in std_logic_vector(4 downto 0); 
		OUT_sr : out std_logic_vector(NBIT - 1 downto 0)); 
end Shifter_Right;

architecture beh of Shifter_Right is

begin
	
	P: process(A, Shift_Amount)
	variable A_shifted : std_logic_vector(NBIT - 1 downto 0);
	variable Shift_Amount_int : integer;
	begin
		Shift_Amount_int := conv_integer(Shift_Amount);
		A_shifted := A;
		for i in 0 to Shift_Amount_int loop
				A_shifted := A_shifted(NBIT - 1) & A_shifted(NBIT - 1 downto 1);
		end loop;	
		OUT_sr <= A_shifted;
	end process;
	
	
end beh;