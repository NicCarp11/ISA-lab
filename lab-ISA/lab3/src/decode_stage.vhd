library ieee;
library work;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use work.my_pkg.all;

entity decode_stage is
port(
clk: in std_logic;
reset: in std_logic;
INSTRUCTION_in: in std_logic_vector(31 downto 0);
address_WB: in std_logic_vector(4 downto 0); -- instruction from writeback stage, we take the destination register from this instruction
--
INST_TYPE: in instruction;
Register_file_write_data: in std_logic_vector (31 downto 0);
Register_file_write_enable: in std_logic; --write enable for register file from control unit
Program_counter: in std_logic_vector(31 downto 0);
STALL: in std_logic;
is_branch_taken_id: out std_logic; --by comparing the value in the RF, I can determine if the branch is taken or not
target_address: out std_logic_vector(31 downto 0); --target address for branch
A: out std_logic_vector(31 downto 0); --operand A
B: out std_logic_vector(31 downto 0); --operand B
immediate_out: out std_logic_vector(31 downto 0); --immediate value
INSTRUCTION_OUT: out std_logic_vector(31 downto 0); --instruction to be sent to execute stage
INST_TYPE_OUT: out instruction; --instruction type to be sent to execute stage
PC_OUT: out std_logic_vector(31 downto 0)); --program counter to be sent to execute stage, and then propagated until writeback stage
end decode_stage;
architecture beh of decode_stage is

    component register_file
    generic (
    NBIT_DATA : integer := 32;
    ADDRESS_BIT : integer := 5
);

port(
    clk : in std_logic;
    reset : in std_logic;
    write_enable : in std_logic;
    write_address : in std_logic_vector(ADDRESS_BIT-1 downto 0);
    write_data : in std_logic_vector(NBIT_DATA-1 downto 0);
    read_address1 : in std_logic_vector(ADDRESS_BIT-1 downto 0);
    read_address2 : in std_logic_vector(ADDRESS_BIT-1 downto 0);
    read_data1 : out std_logic_vector(NBIT_DATA-1 downto 0);
    read_data2 : out std_logic_vector(NBIT_DATA-1 downto 0)
);
end component;
component BRANCH_JUMP_RET_DETECTION is
    port(
        PC: in std_logic_vector(31 downto 0);
        register_source1: in std_logic_vector(31 downto 0);
        register_source2: in std_logic_vector(31 downto 0);
        INST_TYPE: in Instruction;
        STALL: in std_logic;
        Immediate: in std_logic_vector(31 downto 0);
        is_branch_taken_ID: out std_logic;
        PC_ID: out std_logic_vector(31 downto 0));
end component;

component immediate_generation
port(
    inst_code: in std_logic_vector(NBIT-1 downto 0);
    inst: in INSTRUCTION;
    imm_out: out std_logic_vector(NBIT-1 downto 0)
);


end component;

component Shifter_Left1
	port(
	A : in std_logic_vector(NBIT - 1 downto 0); 
	Out_sl : out std_logic_vector(NBIT - 1 downto 0)); 
end component;

--signal effective_A: std_logic_vector(31 downto 0);
--signal effective_B: std_logic_vector(31 downto 0);
--signal effective_IMM: std_logic_vector(31 downto 0);
signal immediate : std_logic_vector(31 downto 0);
signal immediate_2 : std_logic_vector(31 downto 0);
signal first_operand: std_logic_vector(31 downto 0);
signal second_operand: std_logic_vector(31 downto 0);
signal immediate_shifted_2: std_logic_vector(31 downto 0);

begin 
SHIFTERl : Shifter_Left1 port map(A => Immediate_2, OUT_sl => immediate_shifted_2);
Reg_File: register_file generic map(
NBIT_DATA => 32, ADDRESS_BIT => 5) 
port map(
clk=>clk, 
reset=>reset, 
write_enable=>Register_file_write_enable, 
write_address=>address_wb, 
write_data=>Register_file_write_data,
read_address1 =>INSTRUCTION_in(19 downto 15), 
read_address2=>INSTRUCTION_in(24 downto 20), 
read_data1=>first_operand, 
read_data2=>second_operand);

branch_jump_ret: BRANCH_JUMP_RET_DETECTION port map(
PC => Program_counter,
register_source1 => first_operand,
register_source2 => second_operand,
INST_TYPE => INST_TYPE,
STALL => STALL,
Immediate => immediate_shifted_2,
is_branch_taken_ID => is_branch_taken_id,
PC_ID => target_address);

IMM_GEN: immediate_generation port map(
inst_code => INSTRUCTION_in, 
inst => INST_TYPE, 
imm_out=>immediate_2);
    
immediate_out <= immediate_2 when STALL = '0' else (others => '0');
    
--target_address <= (Program_counter + immediate_2) when STALL = '0' and INST_TYPE = BNE or BLE or JAL else
-- 		 immediate_2 when INST_TYPE = J and STALL ='0' else 
--         (others => '0');

 
   A <= first_operand; --when STALL = '0' else (others => '0');
   B <= second_operand; -- when STALL = '0' else (others => '0');


    

INSTRUCTION_OUT <= INSTRUCTION_in;
PC_OUT <= Program_counter;
INST_TYPE_OUT <= INST_TYPE;

end beh;
