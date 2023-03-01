library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_signed.all;
use work.my_pkg.all;

entity BRANCH_JUMP_RET_DETECTION is
    port(
        PC: in std_logic_vector(31 downto 0);
        register_source1: in std_logic_vector(31 downto 0);
        register_source2: in std_logic_vector(31 downto 0);
        INST_TYPE: in Instruction;
        STALL: in std_logic;
        Immediate: in std_logic_vector(31 downto 0);
        is_branch_taken_ID: out std_logic;
        PC_ID: out std_logic_vector(31 downto 0));
end entity BRANCH_JUMP_RET_DETECTION;

architecture Behavioral of BRANCH_JUMP_RET_DETECTION is




begin
    
   branch_ret_jump_det: process (INST_TYPE, STALL) 
        begin 
        if (STALL = '1') then
            is_branch_taken_ID <= '1';
        elsif  (INST_TYPE = BLE) then 
            if ((conv_integer(register_source1) < conv_integer(register_source2)) or (conv_integer(register_source1) = conv_integer(register_source2)) ) then
                is_branch_taken_ID <= '1';
            else
                is_branch_taken_ID <= '0';
            end if;
            elsif (INST_TYPE = BNE) then 
            if (conv_integer(register_source1) /= conv_integer(register_source2)) then
                is_branch_taken_ID <= '1';
            else
                is_branch_taken_ID <= '0';
            end if;
            elsif ((INST_TYPE = JAL) or (INST_TYPE = RET)) then 
                is_branch_taken_ID <= '1';
            else
                is_branch_taken_ID <= '0';
            end if;
      
    end process;
    target_address: process (INST_TYPE, STALL) 
                begin
                if (STALL = '1') then
                    PC_ID <= (others => '0');
                elsif (INST_TYPE = JAL) then
                        PC_ID <= PC + immediate+4;
                    elsif (INST_TYPE = RET) then
                        PC_ID <= register_source1+4;
                    elsif ((INST_TYPE = BLE) or (INST_TYPE = BNE)) then
                        PC_ID <= PC + immediate+4;
					else 
					PC_ID <= (others => '0');
                    end if;
                
            end process;

end Behavioral;


