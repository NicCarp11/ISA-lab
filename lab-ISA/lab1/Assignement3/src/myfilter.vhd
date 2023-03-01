library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_textio.all;

library std;
use std.textio.all;


entity myfilter is
   generic (
    NBIT : integer := 10);
  port (
    CLK     : in  std_logic;
    RST_n   : in  std_logic;
    Vin    : in std_logic;
    Din3k    : in std_logic_vector(NBIT-1 downto 0);
    Din3k1    : in std_logic_vector(NBIT-1 downto 0);
    Din3k2    : in std_logic_vector(NBIT-1 downto 0);
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
    Dout3k    : out std_logic_vector(NBIT-1 downto 0);
    Dout3k1    : out std_logic_vector(NBIT-1 downto 0);
    Dout3k2    : out std_logic_vector(NBIT-1 downto 0)
    
    );
end myfilter;




architecture Behavioural of myfilter is

--matrix of 10 array elements
type Mat is array (10 downto 0) of std_logic_vector (NBIT-1 downto 0);

--internal signals of the architecture
signal Din3k_r, Din3k1_r, Din3k2_r, Dout3k_r, Dout3k1_r, Dout3k2_r,
out_D_3_0, out_2D_3_0, out_3D_3_0,
out_D_3_1, out_2D_3_1, out_3D_3_1,
out_D_3_2, out_2D_3_2, out_3D_3_2, out_4D_3_2: std_logic_vector(NBIT-1 downto 0);
signal Vin_r, Vin_rr: std_logic;
signal B_r, Mul_3k_sh_r, Mul_3k1_sh_r, Mul_3k2_sh_r, Mul_3k_sh_rr, Mul_3k1_sh_rr, Mul_3k2_sh_rr: Mat;


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



begin

--allocation of the registers to store the inputs DIN in parallel
reg_input3k: reg port map (DIN3k, Din3k_r, clk, rst_n, Vin);
reg_input3k1: reg port map (DIN3k1, Din3k1_r, clk, rst_n, Vin); 
reg_input3k2: reg port map (DIN3k2, Din3k2_r, clk, rst_n, Vin);  


--allocation of the register to store the outputs computed in parallel
reg_output3k: reg port map (Dout3k_r, Dout3k, clk, rst_n, Vin_rr);
reg_output3k1: reg port map (Dout3k1_r, Dout3k1, clk, rst_n, Vin_rr); 
reg_output3k2: reg port map (Dout3k2_r, Dout3k2, clk, rst_n, Vin_rr); 


--allocation of the registers to store the inputs delayed
reg_D_x3k: reg port map (DIN3k_r, out_D_3_0, clk, rst_n, Vin);
reg_2D_x3k: reg port map (out_D_3_0, out_2D_3_0, clk, rst_n, Vin);
reg_3D_x3k: reg port map (out_2D_3_0, out_3D_3_0, clk, rst_n, Vin);

reg_D_x3k1: reg port map (DIN3k1_r, out_D_3_1, clk, rst_n, Vin);
reg_2D_x3k1: reg port map (out_D_3_1, out_2D_3_1, clk, rst_n, Vin);
reg_3D_x3k1: reg port map (out_2D_3_1, out_3D_3_1, clk, rst_n, Vin);

reg_D_x3k2: reg port map (DIN3k2_r, out_D_3_2, clk, rst_n, Vin);
reg_2D_x3k2: reg port map ( out_D_3_2, out_2D_3_2, clk, rst_n, Vin);
reg_3D_x3k2: reg port map ( out_2D_3_2, out_3D_3_2, clk, rst_n, Vin);
reg_4D_x3k2: reg port map ( out_3D_3_2, out_4D_3_2, clk, rst_n, Vin);


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


--allocation of the register that gives the enable signal Vin_r of the internal
--registers of the architecture
reg_Vinr: reg_valid port map (Vin, Vin_r, clk, rst_n, '1');

--allocation of the register that gives the enable signal Vin_rr of the internal
--registers of the architecture after the pipe registers
reg_Vinrr: reg_valid port map (Vin_r, Vin_rr, clk, rst_n, '1');

--allocation of the register that gives the Vout signal
reg_Vout: reg_valid port map (Vin_rr, Vout, clk, rst_n, '1');


--pipe registers
reg_mul: for j in 0 to 10 generate
reg_mul_3k_j:reg port map (Mul_3k_sh_r(j),Mul_3k_sh_rr(j), clk, rst_n, Vin_r); 
reg_mul_3k1_j:reg port map (Mul_3k1_sh_r(j),Mul_3k1_sh_rr(j), clk, rst_n, Vin_r);
reg_mul_3k2_j: reg port map (Mul_3k2_sh_r(j),Mul_3k2_sh_rr(j), clk, rst_n, Vin_r);
end generate;



--COMBINATIONAL PROCESS: MULTIPLICATION PART
mul_part: process (Din3k_r, Din3k1_r, Din3k2_r)

variable Mul_3k_sh, Mul_3k1_sh, Mul_3k2_sh: Mat;
variable res_mul: std_logic_vector (2*NBit -1 downto 0);

begin

-- Multiplications for 3k inputs
res_mul:= signed(b_r(0)) * signed(Din3k_r);
Mul_3k_sh(0):= res_mul(19)&res_mul(19 downto 11);

res_mul:= signed(b_r(1)) * signed(out_D_3_2);
Mul_3k_sh(1):= res_mul(19)&res_mul(19 downto 11);

res_mul:= signed(b_r(2)) * signed(out_D_3_1);
Mul_3k_sh(2):= res_mul(19)&res_mul(19 downto 11);

res_mul:= signed(b_r(3)) * signed(out_D_3_0);
Mul_3k_sh(3):= res_mul(19)&res_mul(19 downto 11);

res_mul:= signed(b_r(4)) * signed(out_2D_3_2);
Mul_3k_sh(4):= res_mul(19)&res_mul(19 downto 11);

res_mul:= signed(b_r(5)) * signed(out_2D_3_1);
Mul_3k_sh(5):= res_mul(19)&res_mul(19 downto 11);

res_mul:= signed(b_r(6)) * signed(out_2D_3_0);
Mul_3k_sh(6):= res_mul(19)&res_mul(19 downto 11);

res_mul:= signed(b_r(7)) * signed(out_3D_3_2);
Mul_3k_sh(7):= res_mul(19)&res_mul(19 downto 11);

res_mul:= signed(b_r(8)) * signed(out_3D_3_1);
Mul_3k_sh(8):= res_mul(19)&res_mul(19 downto 11);

res_mul:= signed(b_r(9)) * signed(out_3D_3_0);
Mul_3k_sh(9):= res_mul(19)&res_mul(19 downto 11);

res_mul:= signed(b_r(10)) * signed(out_4D_3_2);
Mul_3k_sh(10):= res_mul(19)&res_mul(19 downto 11);




-- Multiplications for (3k+1) inputs
res_mul:= signed(b_r(0)) * signed(Din3k1_r);
Mul_3k1_sh(0):= res_mul(19)&res_mul(19 downto 11);

res_mul:= signed(b_r(1)) * signed(Din3k_r);
Mul_3k1_sh(1):= res_mul(19)&res_mul(19 downto 11);

res_mul:= signed(b_r(2)) * signed(out_D_3_2);
Mul_3k1_sh(2):= res_mul(19)&res_mul(19 downto 11);

res_mul:= signed(b_r(3)) * signed(out_D_3_1);
Mul_3k1_sh(3):= res_mul(19)&res_mul(19 downto 11);

res_mul:= signed(b_r(4)) * signed(out_D_3_0);
Mul_3k1_sh(4):= res_mul(19)&res_mul(19 downto 11);

res_mul:= signed(b_r(5)) * signed(out_2D_3_2);
Mul_3k1_sh(5):= res_mul(19)&res_mul(19 downto 11);

res_mul:= signed(b_r(6)) * signed(out_2D_3_1);
Mul_3k1_sh(6):= res_mul(19)&res_mul(19 downto 11);

res_mul:= signed(b_r(7)) * signed(out_2D_3_0);
Mul_3k1_sh(7):= res_mul(19)&res_mul(19 downto 11);

res_mul:= signed(b_r(8)) * signed(out_3D_3_2);
Mul_3k1_sh(8):= res_mul(19)&res_mul(19 downto 11);

res_mul:= signed(b_r(9)) * signed(out_3D_3_1);
Mul_3k1_sh(9):= res_mul(19)&res_mul(19 downto 11);

res_mul:= signed(b_r(10)) * signed(out_3D_3_0);
Mul_3k1_sh(10):= res_mul(19)&res_mul(19 downto 11);




-- Multiplications for (3k+2) inputs
res_mul:= signed(b_r(0)) * signed(Din3k2_r);
Mul_3k2_sh(0):= res_mul(19)&res_mul(19 downto 11);

res_mul:= signed(b_r(1)) * signed(Din3k1_r);
Mul_3k2_sh(1):= res_mul(19)&res_mul(19 downto 11);

res_mul:= signed(b_r(2)) * signed(Din3k_r);
Mul_3k2_sh(2):= res_mul(19)&res_mul(19 downto 11);

res_mul:= signed(b_r(3)) * signed(out_D_3_2);
Mul_3k2_sh(3):= res_mul(19)&res_mul(19 downto 11);

res_mul:= signed(b_r(4)) * signed(out_D_3_1);
Mul_3k2_sh(4):= res_mul(19)&res_mul(19 downto 11);

res_mul:= signed(b_r(5)) * signed(out_D_3_0);
Mul_3k2_sh(5):= res_mul(19)&res_mul(19 downto 11);

res_mul:= signed(b_r(6)) * signed(out_2D_3_2);
Mul_3k2_sh(6):= res_mul(19)&res_mul(19 downto 11);

res_mul:= signed(b_r(7)) * signed(out_2D_3_1);
Mul_3k2_sh(7):= res_mul(19)&res_mul(19 downto 11);

res_mul:= signed(b_r(8)) * signed(out_2D_3_0);
Mul_3k2_sh(8):= res_mul(19)&res_mul(19 downto 11);

res_mul:= signed(b_r(9)) * signed(out_3D_3_2);
Mul_3k2_sh(9):= res_mul(19)&res_mul(19 downto 11);

res_mul:= signed(b_r(10)) * signed(out_3D_3_1);
Mul_3k2_sh(10):= res_mul(19)&res_mul(19 downto 11);




for j in 0 to 10 loop
Mul_3k_sh_r(j) <= Mul_3k_sh(j);
Mul_3k1_sh_r(j) <= Mul_3k1_sh(j);
Mul_3k2_sh_r(j) <= Mul_3k2_sh(j);
end loop;
end process;





--COMBINATIONAL PROCESS: SUM PART
sum_part: process (Mul_3k_sh_rr, Mul_3k1_sh_rr, Mul_3k2_sh_rr)
variable Add_all_mul_3k, Add_all_mul_3k1, Add_all_mul_3k2: std_logic_vector (NBIT-1 DOWNTO 0);
begin

for j in 0 to 10 loop
Add_all_mul_3k:=signed(Add_all_mul_3k)+signed(Mul_3k_sh_rr(j));
end loop;
Dout3k_r<=Add_all_mul_3k(7 downto 0) & ("00");
Add_all_mul_3k:=(others=>'0');

for j in 0 to 10 loop
Add_all_mul_3k1:=signed(Add_all_mul_3k1)+signed(Mul_3k1_sh_rr(j));
end loop;
Dout3k1_r<=Add_all_mul_3k1(7 downto 0) & ("00");
Add_all_mul_3k1:=(others=>'0');

for j in 0 to 10 loop
Add_all_mul_3k2:=signed(Add_all_mul_3k2)+signed(Mul_3k2_sh_rr(j));
end loop;
Dout3k2_r<=Add_all_mul_3k2(7 downto 0) & ("00");
Add_all_mul_3k2:=(others=>'0');

end process;
end Behavioural;
