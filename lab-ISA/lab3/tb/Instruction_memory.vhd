library ieee;
library work;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use work.my_pkg.all;

entity IMEM is 
port (
reset: in std_logic;
PC_IN : in std_logic_vector (31 downto 0);
INSTRUCTION_IMEM: out std_logic_vector (31 downto 0));
end IMEM;

architecture beh of IMEM is 

type Imem_vec is array (37 downto 0) of bit_vector(31 downto 0);

signal PC: std_logic_vector (31 downto 0);
signal inst_memory: Imem_vec := (
        x"00008067",
        x"00060513",
        x"fee512e3",
        x"00078613",
        x"00c7d463",
        x"40d787b3",
        x"00f6c7b3",
        x"41f7d693",
        x"00470713",
        x"00072783",
        x"00b50533",
        x"00450713",
        x"00259593",
        x"02b75863",
        x"40f60633",
        x"00c7c633",
        x"41f65793",
        x"00100713",
        x"00052603",
        x"00008067",
        x"01010113",
        x"00000513",
        x"00a7ae23",
        x"100107b7",
        x"00c12083",
        x"01c000ef",
        x"00112623",
        x"00050513",
        x"00700593",
        x"ff010113",
        x"10010537",
        x"0000006f",
        x"008000ef",
        x"00010433",
        x"ff410113",
        x"7fbff117",
        x"01c18193",
        x"1fc18197"
	
		
);
begin
PC <= PC_IN-4;

Instr_process: process (PC, reset) 
begin
if conv_integer(PC(31 downto 2)) < 38 then 
INSTRUCTION_IMEM <= to_stdlogicvector(inst_memory(conv_integer((PC(31 downto 2)))));
else 
INSTRUCTION_IMEM <= (others=>'0');
end if;

if (reset = '1') then
INSTRUCTION_IMEM <= (others=>'0');
end if;
end process;
end beh;





 
 
 
 
 
