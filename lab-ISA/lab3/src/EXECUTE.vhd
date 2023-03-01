library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use work.my_pkg.all;

entity EXECUTE is 
	port(	
		PC		 		 : in std_logic_vector(NBIT - 1 downto 0); 
		Control_alu	     : in instruction; 
		A 				 : in std_logic_vector(NBIT - 1 downto 0); -- vengono dalla Decode
		B 				 : in std_logic_vector(NBIT - 1 downto 0); -- vengono dalla Decode
		Immediate 	     : in std_logic_vector(NBIT - 1 downto 0); -- vengono dalla Decode
		Sel_muxA 		 : in std_logic; --vengono dalla control unit
		Sel_muxB 		 : in std_logic; --vengono dalla control unit
		OUT_alu 		 : out std_logic_vector(NBIT - 1 downto 0));
		--PC_out		 :out std_logic_vector(NBIT - 1 downto 0));
end EXECUTE;

architecture struct of EXECUTE is

component ALU
	port(
		A : in std_logic_vector(NBIT - 1 downto 0); 
		B : in std_logic_vector(NBIT - 1 downto 0); 
		Control_alu : in instruction; -- chi fa il package deve chiamare instruction e no INST questo tipo
		OUT_alu : out std_logic_vector(NBIT - 1 downto 0) 
		); 
end component;

component mux2_1
		port(
		IN0_mux : in std_logic_vector(NBIT -1 downto 0);
		IN1_mux : in std_logic_vector(NBIT -1 downto 0);
		sel_mux : in std_logic;
		out_mux : out std_logic_vector(NBIT -1 downto 0));
end component;
	
--component adder
--      port(
--		IN0_add : in std_logic_vector(NBIT -1 downto 0);
--		IN1_add : in std_logic_vector(NBIT -1 downto 0);
--		Control_adder : in std_logic_vector(NBIT -1 downto 0);
--		out_add : out std_logic_vector(NBIT -1 downto 0));
--end component;


--component Shifter_Left1
--	port(
--	A : in std_logic_vector(NBIT - 1 downto 0); 
--	Out_sl : out std_logic_vector(NBIT - 1 downto 0)); 
--end component;


signal ALU_B : std_logic_vector(NBIT - 1 downto 0);
signal ALU_A : std_logic_vector(NBIT - 1 downto 0);
--signal ALU_out : std_logic_vector(NBIT - 1 downto 0);
--signal Shifted_Immediate : std_logic_vector(NBIT - 1 downto 0);


	
begin

	ALU_i : ALU port map(A => ALU_A, B => ALU_B, Control_alu => Control_alu, OUT_alu => OUT_alu);
	
	--OUT_alu <= ALU_out;
	
	MUX21_I : mux2_1 port map(IN0_mux => B, IN1_mux => Immediate, sel_mux => Sel_muxB, out_mux => ALU_B);--da aggiustare,mettere 4 come 3o input(nn più)
	MUX21_II:  mux2_1 port map(IN0_mux => A, IN1_mux => PC, sel_mux => Sel_muxA, out_mux => ALU_A);
	--SHIFTERl : Shifter_Left1 port map(A => Immediate, OUT_sl => Shifted_Immediate);
	
	--ADDER : adder port map(IN0_add => PC, IN1_add => Shifted_Immediate, Control_adder => ALU_out, out_add => PC_out);
	
	--aggiungere altri segnali di uscita rd e rs2(B)
	 
end struct;
