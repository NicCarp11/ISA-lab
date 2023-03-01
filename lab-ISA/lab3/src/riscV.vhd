library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;
use work.my_pkg.all;

entity RISC is
    PORT (
        CLK: in std_logic;
        RESET: in std_logic;
        data_in_mem : out std_logic_vector(31 downto 0);
        address_mem_or_ALU_result: inout std_logic_vector(31 downto 0);
        mem_en: out std_logic;
        data_out_mem: in std_logic_vector(31 downto 0);
        read_not_write: out std_logic;
        PC_for_iMem: inout std_logic_vector(31 downto 0);
        INSTRUCTION_OUT_IMEM: in std_logic_vector(31 downto 0));

end RISC;

architecture struct of RISC is
    component FETCH 
        port(
            CLK               : in std_logic; -- clock signal
            RST               : in std_logic; -- active high reset
            STALL			  : in std_logic; -- stall signal from HU
            PC_ID			  : in std_logic_vector(NBIT - 1 downto 0); -- target address coming from ID when a branch is decoded
            SEL_MUX           : in std_logic; -- selector of the multiplexer of PCs
            
            PC_TO_IMEM        : inout std_logic_vector(NBIT - 1 downto 0)); -- PC to be given to the IRAM
    end component;

    component pipeline_reg_IF_ID 
        port(
            CLK: in std_logic;
            reset: in std_logic;
            PC_out_fetch: in std_logic_vector(31 downto 0);
            is_branch_taken_ID: in std_logic;
            instruction_out_fetch: in std_logic_vector(31 downto 0);
            INST_TYPE_out_fetch: in Instruction;
            PC_in_decode: out std_logic_vector(31 downto 0);
            instruction_in_decode: out std_logic_vector(31 downto 0);
            INST_TYPE_in_decode: out Instruction
            );
        end component;

    component decode_stage 
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
        end component;

    component pipeline_reg_ID_EX 
        port(
        clk: in std_logic;
        reset: in std_logic;
        stall : in std_logic;
        A_out_ID: in std_logic_vector(31 downto 0);
        B_out_ID: in std_logic_vector(31 downto 0);
        imm_out_ID: in std_logic_vector(31 downto 0);
        PC_out_ID: in std_logic_vector(31 downto 0);
        instruction_out_ID: in std_logic_vector(31 downto 0);
        inst_type_out_ID: in Instruction;
        A_in_EX: out std_logic_vector(31 downto 0);
        B_in_EX: out std_logic_vector(31 downto 0);
        imm_in_EX: out std_logic_vector(31 downto 0);
        PC_in_EX: out std_logic_vector(31 downto 0);
        instruction_in_EX: out std_logic_vector(31 downto 0);
        data_write_mem: out std_logic_vector(31 downto 0);
        inst_type_in_EX: out Instruction
        );
        end component;

    component EXECUTE  
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
        end component;

    component pipeline_reg_EX_MEM  
    port (
    clk: in std_logic;
    reset: in std_logic;
    out_ALU_or_address_MEM: in std_logic_vector(31 downto 0);
    inst_type_out_EX: in Instruction;
    instruction_out_EX: in std_logic_vector(31 downto 0);
    data_write_out_EX: in std_logic_vector(31 downto 0); --coming from pipeline ID/EX
    ALU_or_address_MEM_in: out std_logic_vector(31 downto 0);
    inst_type_in_MEM: out Instruction;
    instruction_in_MEM: out std_logic_vector(31 downto 0);
    data_write_in_MEM: out std_logic_vector(31 downto 0)
    );
        end component;

    component pipeline_reg_MEM_WB  
    port (
    clk: in std_logic;
    reset: in std_logic;
    instruction_out_MEM: in std_logic_vector(31 downto 0);
    ALU_result_out_MEM: in std_logic_vector(31 downto 0);
    write_data_out_MEM: in std_logic_vector(31 downto 0);
    address_RF: out std_logic_vector(4 downto 0);
    ALU_result_in_WB: out std_logic_vector(31 downto 0);
    write_data_in_WB: out std_logic_vector(31 downto 0)
    );
        end component;

     component mux2_1 
            port(
                IN0_mux : in std_logic_vector(NBIT -1 downto 0);
                IN1_mux : in std_logic_vector(NBIT -1 downto 0);
                sel_mux : in std_logic;
                out_mux : out std_logic_vector(NBIT -1 downto 0));
    end component;

    component control_unit  
port(
    clk: in std_logic;
    reset: in std_logic;
    stall: in std_logic;
    INST_TYPE: in instruction;

    sel_mul_A_PC: out std_logic;
    sel_mul_B_imm: out std_logic;
    enable_MEM: out std_logic;
    R_not_W_Mem: out std_logic;
    Mem_not_ALU: out std_logic;
    R_not_W_Reg: out std_logic;
    ALU_op: out Instruction); end component;


component HU 
	port(
rst : in std_logic;
IF_ID_RS1 : in std_logic_vector (RF_SIZE - 1 downto 0);
ID_EX_RD : in std_logic_vector (RF_SIZE - 1 downto 0);
EX_MEM_RD : in std_logic_vector (RF_SIZE - 1 downto 0);
MEM_WB_RD : in std_logic_vector (RF_SIZE - 1 downto 0);
IF_ID_RS2: in std_logic_vector (RF_SIZE - 1 downto 0);
--ID_EX_RS1  : in std_logic_vector(RF_SIZE - 1 downto 0);
--ID_EX_RS2  : in std_logic_vector(RF_SIZE - 1 downto 0);		
ID_EX_OPC  : in instruction;
IF_ID_OPC  : in instruction; 
EX_MEM_OPC : in instruction; 	
STALL    : out std_logic); 
end component;


component I_ENC 
	port(
		Instruction_in_d: in std_logic_vector(31 downto 0);
		
		INSTRUCTION_out   : out instruction);
end component;
signal is_branch_taken_ID: std_logic; --segnale che va in ingresso al reg IF/ID e generato dalla BRANCH_JUMP DET.
signal PC_in_D: std_logic_vector(31 downto 0); 
signal instruction_in_decode: std_logic_vector(31 downto 0);
signal INST_TYPE_DEC: instruction;
signal address_from_write_back: std_logic_vector(4 downto 0);
signal data_from_write_back: std_logic_vector(31 downto 0);
signal Read_not_Write_RF_CU: std_logic;
signal STALL: std_logic;
signal target_address: std_logic_vector(31 downto 0);
signal A_in_pipe_IDEX: std_logic_vector(31 downto 0);
signal B_in_pipe_IDEX: std_logic_vector(31 downto 0);
signal immediate_in_pipe_IDEX: std_logic_vector(31 downto 0);
signal INSTRUCTION_IN_PIPE_IDEX: std_logic_vector(31 downto 0);
signal INST_TYPE_IN_PIPE_IDEX: instruction;
signal PC_in_pipe_IDEX: std_logic_vector(31 downto 0);
signal A_IN_EX: std_logic_vector(31 downto 0);
signal B_IN_EX: std_logic_vector(31 downto 0);
signal immediate_IN_EX: std_logic_vector(31 downto 0);
signal PC_IN_EX: std_logic_vector(31 downto 0);
signal INSTRUCTION_IN_EX: std_logic_vector(31 downto 0);
signal DATA_WRITE_MEM_IN_EX: std_logic_vector(31 downto 0);
signal INST_TYPE_IN_EX: instruction;
signal control_alu_cu: INSTRUCTION;
signal SEL_MUX_A_CU: std_logic;
signal SEL_MUX_B_CU: std_logic;
signal OUT_ALU: std_logic_vector(31 downto 0);
signal INSTRUCTION_IN_MEM: std_logic_vector(31 downto 0);
signal INST_TYPE_IN_MEM: instruction;
signal result_ALU_IN_WB: std_logic_vector(31 downto 0);
signal result_MEM_IN_WB: std_logic_vector(31 downto 0);
signal not_ALU_mem: std_logic;
signal added_DEC_TYPE: Instruction;


begin
pipe_FD:    pipeline_reg_IF_ID port map(
        clk => clk,
        reset => reset,
        PC_OUT_fetch => PC_for_iMem,
        INST_TYPE_out_fetch=> INST_TYPE_DEC,
        is_branch_taken_ID => is_branch_taken_ID,
        instruction_out_fetch => INSTRUCTION_OUT_IMEM,
        PC_in_decode => PC_in_D,
        INST_TYPE_in_decode => added_DEC_TYPE,
        instruction_in_decode => instruction_in_decode);


I_E:    I_ENC port map(
        Instruction_in_d => INSTRUCTION_OUT_IMEM,
        INSTRUCTION_out => INST_TYPE_DEC);
    
DE:    decode_stage port map(
        clk => clk,
        reset => reset,
        INSTRUCTION_IN => instruction_in_decode,
        address_WB => address_from_write_back,
        INST_TYPE => added_DEC_TYPE,
        Register_file_write_data => data_from_write_back,
        Register_file_write_enable => Read_not_Write_RF_CU,
        Program_counter => PC_in_D,
        STALL=> STALL,
        is_branch_taken_ID => is_branch_taken_ID,
        target_address => target_address,
        A => A_in_pipe_IDEX,
        B => B_in_pipe_IDEX,
        immediate_out => immediate_in_pipe_IDEX,
        INSTRUCTION_OUT=> INSTRUCTION_IN_PIPE_IDEX,
        INST_TYPE_OUT => INST_TYPE_IN_PIPE_IDEX,
        PC_OUT => PC_in_pipe_IDEX
        );

pipe_DE:    pipeline_reg_ID_EX port map(
        clk => clk,
        reset => reset,
        stall => stall,
        A_OUT_ID => A_in_pipe_IDEX,
        B_OUT_ID => B_in_pipe_IDEX,
        imm_out_id => immediate_in_pipe_IDEX,
        PC_OUT_ID => PC_in_pipe_IDEX,
        instruction_out_ID => INSTRUCTION_IN_PIPE_IDEX,
        inst_type_out_ID => INST_TYPE_IN_PIPE_IDEX,
        A_IN_EX => A_IN_EX,
        B_IN_EX => B_IN_EX,
        imm_IN_EX => immediate_IN_EX,
        PC_in_EX => PC_IN_EX,
        instruction_in_EX => INSTRUCTION_IN_EX,
        data_write_mem => DATA_WRITE_MEM_IN_EX,
        inst_type_in_EX => INST_TYPE_IN_EX
        );

Ex: EXECUTE port map(
        PC => PC_IN_EX,
        control_alu => control_alu_cu,
        A => A_IN_EX,
        B => B_IN_EX,
        immediate => immediate_IN_EX,
        sel_muxA => SEL_MUX_A_CU,
        sel_muxB => SEL_MUX_B_CU,
        OUT_ALU => OUT_ALU);

pipe_EM: pipeline_reg_EX_MEM port map (
        clk => clk,
        reset => reset,
        out_ALU_or_address_MEM => OUT_ALU,
        inst_type_out_EX => INST_TYPE_IN_EX,
        instruction_out_EX => INSTRUCTION_IN_EX,
        data_write_out_EX => DATA_WRITE_MEM_IN_EX,
        ALU_or_ADDRESS_MEM_IN => address_mem_or_ALU_result,
        data_write_in_MEM => data_in_mem,
        instruction_in_MEM => INSTRUCTION_IN_MEM,
        inst_type_in_MEM => INST_TYPE_IN_MEM );

pipe_MW: pipeline_reg_MEM_WB port map (
        clk => clk,
        reset => reset,
        instruction_out_MEM => INSTRUCTION_IN_MEM,
        ALU_result_out_MEM => address_mem_or_ALU_result,
        write_data_out_MEM => data_out_mem,
        address_RF => address_from_write_back,
        ALU_result_in_WB => result_ALU_IN_WB,
        write_data_In_WB =>  result_MEM_IN_WB
    );


mux_wb: mux2_1 port map (
    IN0_mux => result_ALU_IN_WB,
    IN1_MUX => result_MEM_IN_WB,
    sel_MUX => not_ALU_mem,
    out_mux => data_from_write_back
);

F: FETCH port map(
    clk => clk, 
    RST => reset,
    stall => stall,
    PC_ID => target_address,
    sel_MUX => is_branch_taken_ID,
    PC_TO_IMEM => PC_for_iMem
);

HZ: HU port map (
    rst => reset,
    IF_ID_RS1 => instruction_in_decode(19 downto 15),
    ID_EX_RD => INSTRUCTION_IN_EX(11 downto 7),
    EX_MEM_RD => INSTRUCTION_IN_MEM(11 DOWNTO 7),
    MEM_WB_RD => address_from_write_back,
    IF_ID_RS2 => instruction_in_decode(24 downto 20),
    ID_EX_OPC => INST_TYPE_IN_EX,
    IF_ID_OPC => added_DEC_TYPE,
    EX_MEM_OPC => INST_TYPE_IN_MEM,
    STALL => STALL
);

CU: control_unit port map (
    clk => clk,
    reset => reset,
    stall => stall, 
    INST_TYPE => added_DEC_TYPE,
    sel_mul_A_pc => SEL_MUX_A_CU,
    sel_mul_B_imm => SEL_MUX_B_CU,
    enable_MEM => mem_en,
    R_not_W_Mem => read_not_write,
    Mem_not_ALU => not_ALU_mem,
    R_not_W_reg => Read_not_Write_RF_CU,
    ALU_OP => control_alu_cu);



    end struct;
