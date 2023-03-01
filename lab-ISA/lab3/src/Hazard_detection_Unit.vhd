library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_signed.all;
use work.my_pkg.all;

entity HU is
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
end HU;

architecture Behavioral of HU is
   
begin
Hazard_det: process (rst, IF_ID_RS1, ID_EX_RD, EX_MEM_RD, MEM_WB_RD, IF_ID_RS2, ID_EX_OPC, IF_ID_OPC, EX_MEM_OPC)
    begin
        if (rst = '1') then
            STALL <= '0';
         else --analyze only the instruction with a source register
            
            if (IF_ID_OPC /= AUIPC and IF_ID_OPC /= JAL and IF_ID_OPC /= LUI and (unsigned(ID_EX_RD) > 0) AND (unsigned(EX_MEM_RD)>0))  then 
                -- analyze the instruction with a rs1 and a rs2
             -- STALL IN EXECUTE
                if (IF_ID_OPC /= BLE and IF_ID_OPC /= BNE) then
                    if (IF_ID_RS1 = ID_EX_RD or IF_ID_RS1 = EX_MEM_RD ) then
                        STALL <= '1';
                        -- analyze the instruction with a rs1 and a rs2
                    elsif ((IF_ID_RS2 = ID_EX_RD or IF_ID_RS2 = EX_MEM_RD) and IF_ID_OPC /= ADDI and IF_ID_OPC /= SRAI and IF_ID_OPC /= LW and IF_ID_OPC /= SLLI) then
                        STALL <= '1';
                    else
                        STALL <= '0';
                    end if;
                elsif (IF_ID_OPC = BNE or IF_ID_OPC = BLE) then
                    if (IF_ID_RS1 = ID_EX_RD or IF_ID_RS2 = ID_EX_RD or IF_ID_RS1 = EX_MEM_RD or IF_ID_RS2 = EX_MEM_RD) then
                        STALL <= '1';
                    else
                        STALL <= '0';
                    end if;
                 
                else
                stall <= '0';
                end if;
            else 
            STALL <= '0';
            end if;
        end if;
                        


    end process Hazard_det;
end Behavioral;
