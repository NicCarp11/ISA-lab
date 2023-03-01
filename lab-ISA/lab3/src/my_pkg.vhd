library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

package my_pkg is

constant NBIT	: integer :=32;
constant RF_SIZE : integer := 5;

type instruction is (AUIPC, ADDI, ADD, JAL, J, LUI, LI, MV, SW, LW, SRAI, XOR_op, SUB, BLE, SLLI, BNE, RET);
end package;
