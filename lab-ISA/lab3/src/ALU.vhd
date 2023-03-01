library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use work.my_pkg.all;

entity ALU is
port(
		A : in std_logic_vector(NBIT - 1 downto 0); -- A è rs1 (oppure prendiamo A o PC dal mux)
		B : in std_logic_vector(NBIT - 1 downto 0); -- B dal mux che è o RS2 o imm
		Control_alu : in instruction;
		OUT_alu : out std_logic_vector(NBIT - 1 downto 0) 
		); 
end ALU;

architecture beh of ALU is

component Shifter_Right
	port(
	A : in std_logic_vector(NBIT - 1 downto 0); 
	Shift_Amount : in std_logic_vector(4 downto 0); 
	OUT_sr : out std_logic_vector(NBIT - 1 downto 0)); 
end component;

component Shifter_Left
	port(
	A : in std_logic_vector(NBIT - 1 downto 0); 
	Shift_Amount : in std_logic_vector(4 downto 0); 
	OUT_sl : out std_logic_vector(NBIT - 1 downto 0)); 
end component;
	
--signal result_comparation1, result_comparation2 : std_logic_vector (NBIT - 1 downto 0);
signal Shifted_Operand1, Shifted_Operand2: std_logic_vector(NBIT - 1 downto 0);

begin

	--result_comparation1 <= (others => '1') when (A <= B) else (others => '0');
	--result_comparation2 <= (others => '1') when (A != B) else (others => '0');
	
	
	SHIFTERr : Shifter_Right port map(A => A, Shift_Amount => B(4 downto 0), OUT_sr => Shifted_Operand1);
	SHIFTERl : Shifter_Left port map(A => A, Shift_Amount => B(4 downto 0), OUT_sl => Shifted_Operand2);
	
	OUT_alu <= A + B when Control_alu = AUIPC else --pc+imm
	         A + B when Control_alu = ADDI else --rs1+imm
	         A + B when Control_alu = ADD else --rs1+rs2
			 A + 4 when Control_alu = JAL else --pc+imm
			 --A + 4 when Control_alu = J else --J la ALU non deve fare nulla, il target address già calcolato nella DECODE.
			 B when Control_alu = LUI else --LUI sarebbe imm+0, quindi imm
			 B when Control_alu = LI else--LI sarebbe rd=imm+0, dice che usa anche questo addi, pseudo inst
			 A when Control_alu = MV else --MV credo, sarebbe rs+0 in rd, in realt  una pseudo instr che usa addi, quindi forse non si deve scrivere
			 A + B when Control_alu = SW else -- rs1+imm
			 A + B when Control_alu = LW else -- rs1+imm
			 Shifted_Operand1 when Control_alu = SRAI else
			 A xor B when Control_alu = XOR_op else
			 A - B when Control_alu = SUB else --SUB
			 --"1111111111111111111111111111111" and result_comparation1 when Control_alu = BLE else--BLE più update del PC anticipate nel decodestage
			 Shifted_Operand2 when Control_alu = SLLI else--SLLI
			 --"1111111111111111111111111111111" and result_comparation2 when Control_alu = BNE else--BNE più update del PC anticipate nel decodestage
			 (others => '0');
end architecture;
