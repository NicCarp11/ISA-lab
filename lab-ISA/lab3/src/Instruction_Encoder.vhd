library ieee;
library work;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.my_pkg.all;

entity I_ENC is
	port(
		Instruction_in_d: in std_logic_vector(31 downto 0);
		
		INSTRUCTION_out   : out instruction);
end I_ENC;

architecture beh of I_ENC is


begin

	INSTRUCTION_out <= AUIPC when Instruction_in_d(6 downto 0) = "0010111" else 
		   ADDI when Instruction_in_d(6 downto 0) = "0010011" and Instruction_in_d(14 downto 12) = "000" else -- same for LI and MOVE
		   ADD when Instruction_in_d(6 downto 0) = "0110011" and Instruction_in_d(14 downto 12) = "000" and Instruction_in_d(31 downto 25) = "0000000" else --SAME FOR THE JUMP
		   JAL when Instruction_in_d(6 downto 0) = "1101111" else --same jump
		  LUI when Instruction_in_d(6 downto 0) = "0110111" else 
		   SW when Instruction_in_d(6 downto 0) = "0100011" and Instruction_in_d(14 downto 12) = "010" else
		   LW when Instruction_in_d(6 downto 0) = "0000011" and Instruction_in_d(14 downto 12) = "010" else
		   SRAI when Instruction_in_d(6 downto 0) = "0010011" and Instruction_in_d(14 downto 12) = "101" else
		   SLLI when Instruction_in_d(6 downto 0) = "0010011" and Instruction_in_d(14 downto 12) = "001" else
		   XOR_op when Instruction_in_d(6 downto 0) = "0110011" and Instruction_in_d(14 downto 12) = "100" else
		   SUB when Instruction_in_d(6 downto 0) = "0110011" and Instruction_in_d(14 downto 12) = "000" and Instruction_in_d(30) = '1' else
		   BLE when Instruction_in_d(6 downto 0) = "1100011" and Instruction_in_d(14 downto 12) = "110" else
		   BNE when Instruction_in_d(6 downto 0) = "1100011" and Instruction_in_d(14 downto 12) = "001" else
		   RET when Instruction_in_d(6 downto 0) = "1100111" else
		  LUI;

end beh;
