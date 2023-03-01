library ieee;
library work;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_signed.all;
use work.my_pkg.all;

entity immediate_generation is
	port(
inst_code : IN std_logic_vector (NBIT - 1 downto 0);
inst: in instruction;
imm_out : OUT std_logic_vector (NBIT - 1 downto 0 )
);
end immediate_generation;

architecture beh of immediate_generation is
begin


-- BLE, BNE,JAL, J, MV, SW, LW 
-- LUI, AUIPC, ADDI, LI, SRAI, SLLI


-- according to INSTRUCTION, IMMEDIATE is generated according to the format of each instruction

---LUI, AUIPC
	imm_out <= inst_code(NBIT-1 downto 12) & "000000000000" when (inst = LUI or inst = AUIPC) else
	

---BNE	
	     "0000000000000000000" & inst_code(31) & inst_code(7) & inst_code(30 downto 25) & inst_code(11 downto 8) & '0' when ((inst = BNE or inst = BLE) and inst_code(31) = '0') else 
             "1111111111111111111" & inst_code(31) & inst_code(7) & inst_code(30 downto 25) & inst_code(11 downto 8) & '0' when ((inst = BNE or inst = BLE) and inst_code(31) = '1') else 
				 


						 

						 
--- JAL, J 
				 "00000000000" & inst_code(31) & inst_code(19 downto 12) & inst_code(20) & inst_code(30 downto 21) & '0' when ((inst = JAL ) and inst_code(31) = '0') else
				 "11111111111" & inst_code(31) & inst_code(19 downto 12) & inst_code(20) & inst_code(30 downto 21) & '0' when ((inst = JAL ) and inst_code(31) = '1') else



---SW
				 "000000000000000000000" & inst_code(31 downto 26) & inst_code(11 downto 7) when (inst = SW and inst_code(31) = '0') else
				 "111111111111111111111" & inst_code(31 downto 26) & inst_code(11 downto 7) when (inst = SW and inst_code(31) = '1') else


---LW				 
				 "00000000000000000000" & inst_code(31 downto 20) when (inst = LW and inst_code(31) = '0') else
				 "11111111111111111111" & inst_code(31 downto 20) when (inst = LW and inst_code(31) = '1') else
				 	
				
---ADDI, LI, MV

				 "00000000000000000000" & inst_code(31 downto 20) when ((inst = ADDI) and inst_code(31) = '0') else
				 "11111111111111111111" & inst_code(31 downto 20) when ((inst = ADDI) and inst_code(31) = '1') else
				 

----SRAI, SLLI
				 "00000000000000000000" & "0100000" & inst_code(24 downto 20) when inst = SRAI else	
				 "00000000000000000000" & "0000000" & inst_code(24 downto 20) when inst = SLLI else

(others => '0');
end beh;


