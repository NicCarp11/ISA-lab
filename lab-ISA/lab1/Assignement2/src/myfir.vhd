library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_textio.all;

library std;
use std.textio.all;


entity myfir is
    generic (
    NBIT : integer := 10);
  port (
    CLK     : in std_logic;
    RST_n   : in std_logic;
    Vin     : in std_logic;
    Din     : in std_logic_vector(NBIT-1 downto 0);
    B0      : in std_logic_vector(NBIT-1 downto 0);
    B1      : in std_logic_vector(NBIT-1 downto 0);
    B2      : in std_logic_vector(NBIT-1 downto 0);
    B3      : in std_logic_vector(NBIT-1 downto 0);
    B4      : in std_logic_vector(NBIT-1 downto 0);
    B5      : in std_logic_vector(NBIT-1 downto 0);
    B6      : in std_logic_vector(NBIT-1 downto 0);
    B7      : in std_logic_vector(NBIT-1 downto 0);
    B8      : in std_logic_vector(NBIT-1 downto 0);
    B9      : in std_logic_vector(NBIT-1 downto 0);
    B10     : in std_logic_vector(NBIT-1 downto 0);
    Vout    : out std_logic;
    Dout    : out std_logic_vector(NBIT-1 downto 0)
    );
end myfir;



architecture behavioural of myfir is


--register of 10 bits
component reg is
PORT(
    I: IN std_logic_vector(9 downto 0);
    Q: OUT std_logic_vector(9 downto 0);
    Clk, Rst, en: IN std_logic);
end component;

--register of 1 bit
component reg_valid is
PORT(
    I: IN std_logic;
    Q: OUT std_logic;
    Clk, Rst, en: IN std_logic);
end component;

--matrix of 10 array elements
type Mat is array (10 downto 0) of std_logic_vector (NBIT-1 downto 0);

--internal signals of the architecture
signal Dout_r : std_logic_vector(NBIT-1 DOWNTO 0); 
signal B_r: Mat;
signal out_reg: Mat;
signal Vin_r: std_logic;


begin

--allocation of the registers to store the inputs DIN
reg0: reg port map (DIN, out_reg(0), clk, rst_n, Vin);

REG_P: for i in 0 to 9 generate
reg_i: reg port map (out_reg(i), out_reg(i+1), clk, rst_n, Vin);
end generate;

--allocation of the registers to store the B coefficients
B0_r: reg port map (B0, B_r(0), clk, rst_n, Vin);
B1_r: reg port map (B1, B_r(1), clk, rst_n, Vin);
B2_r: reg port map (B2, B_r(2), clk, rst_n, Vin);
B3_r: reg port map (B3, B_r(3), clk, rst_n, Vin);
B4_r: reg port map (B4, B_r(4), clk, rst_n, Vin);
B5_r: reg port map (B5, B_r(5), clk, rst_n, Vin);
B6_r: reg port map (B6, B_r(6), clk, rst_n, Vin);
B7_r: reg port map (B7, B_r(7), clk, rst_n, Vin);
B8_r: reg port map (B8, B_r(8), clk, rst_n, Vin);
B9_r: reg port map (B9, B_r(9), clk, rst_n, Vin);
B10_r: reg port map (B10, B_r(10), clk, rst_n, Vin);

--allocation of the register to store the outputs coputed
output_reg: reg port map (Dout_r, Dout, clk, rst_n, Vin_r); 

--allocation of the register that gives the enable signal of the internal
--registers of the architecture
reg_Vin: reg_valid port map (Vin, Vin_r, clk, rst_n, '1');

--allocation of the register that gives the Vout signal
reg_Vout: reg_valid port map (Vin_r, Vout, clk, rst_n, '1');



--process to compute the output samples
combinational_process: process(out_reg(0)) 

variable Dout_feed_out: std_logic_vector (NBIT-1 DOWNTO 0);
variable res_mul_conv:  std_logic_vector (NBIT-1 DOWNTO 0);
variable res_mul: std_logic_vector (2*NBit -1 downto 0);
 

begin

for j in 0 to 10 loop
res_mul:= signed(b_r(j)) * signed(out_reg(j));
res_mul_conv:= res_mul(19)&res_mul(19 downto 11);
Dout_feed_out:=signed(Dout_feed_out)+signed(res_mul_conv);
end loop;

Dout_r<=Dout_feed_out(7 downto 0) & ("00");
Dout_feed_out:=(others=>'0');

end process;


end behavioural;
