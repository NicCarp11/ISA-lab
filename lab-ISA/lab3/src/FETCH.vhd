library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use work.my_pkg.all;

entity FETCH is
	port(
		CLK               : in std_logic; -- clock signal
		RST               : in std_logic; -- active high reset
		STALL			  : in std_logic; -- stall signal from HU
		PC_ID			  : in std_logic_vector(NBIT - 1 downto 0); -- target address coming from ID when a branch is decoded
		SEL_MUX           : in std_logic; -- selector of the multiplexer of PCs
		
		PC_TO_IMEM        : inout std_logic_vector(NBIT - 1 downto 0)); -- PC to be given to the IRAM
end FETCH;

architecture struct of FETCH is
	
	component mux2_1
	port(
		IN0_mux : in std_logic_vector(NBIT -1 downto 0);
		IN1_mux : in std_logic_vector(NBIT -1 downto 0);
		sel_mux : in std_logic;
		out_mux : out std_logic_vector(NBIT -1 downto 0));
	end component;

	component register_PC 
	PORT(
    D: IN std_logic_vector(NBIT -1 downto 0);
    Q: OUT std_logic_vector(NBIT -1 downto 0);
    Clk, rst, en: IN std_logic);
	end component;



	signal OUT_PC_MUX : std_logic_vector(NBIT - 1 downto 0);	
	signal NEXT_PC    : std_logic_vector(NBIT - 1 downto 0);
	

begin
	-- right pc selection mux
	PC_MUX : mux2_1 port map(IN0_MUX => NEXT_PC, IN1_MUX => PC_ID, sel_mux => SEL_MUX, out_mux => OUT_PC_MUX);
	
	-- pc register
	PC_REG : register_PC port map(CLK => CLK, RST => RST, EN => STALL, D => OUT_PC_MUX, Q => PC_TO_IMEM);

	-- NPC calculation
	NEXT_PC <= PC_TO_IMEM + 4;
	


end struct;
