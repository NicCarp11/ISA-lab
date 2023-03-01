`include "registers.svh"
`include "full_adder.sv"
`include "half_adder.sv"
`include "compressor_4_2.sv"

module booth_mul #(
  parameter fpnew_pkg::fp_format_e   FpFormat = fpnew_pkg::fp_format_e'(0),
  parameter int unsigned             MAN_BITS = fpnew_pkg::man_bits(FpFormat),
  parameter int unsigned             PRECISION_BITS=MAN_BITS+1

) (
  input  logic                 [PRECISION_BITS-1:0]   mantissa_a,
  input  logic                 [PRECISION_BITS-1:0]   mantissa_b,
  output wire                 [2*PRECISION_BITS-1:0] product
);


logic [PRECISION_BITS+1:0] mantissa_3b;
logic [PRECISION_BITS:0] mantissa_2b_reg;
logic [PRECISION_BITS-1:0] mantissa_a_reg;
logic [PRECISION_BITS-1:0] mantissa_b_reg;
logic [PRECISION_BITS+1:0] mantissa_4b_reg;
logic [2*PRECISION_BITS-1:0] product_reg;
logic [28:0] pp0;
logic [30:0] pp1;
logic [33:0] pp2;
logic [36:0] pp3;
logic [39:0] pp4;
logic [42:0] pp5;
logic [45:0] pp6;
logic [47:0] pp7;
logic [7:0][25:0] pp_booth; 
logic [7:0][25:0] n_ext; 
logic [3:0] m7;
logic [6:0][1:0] m;
logic [7:0] r;
logic [3:0] q;
wire [37:0] pp_3_0;
wire [39:0] pp_3_1;
wire [42:0] pp_3_2;
wire [45:0] pp_3_3;
wire [47:0] pp_3_4; 
wire [43:0] pp_2_0;
wire [45:0] pp_2_1;
wire [47:0] pp_2_2;
wire [46:0] pp_1_0;
wire [47:0] pp_1_1;
logic [47:0] pp_f1;
logic [46:0] pp_f2;


always @* begin
mantissa_a_reg = mantissa_a>>1;
mantissa_b_reg=mantissa_b >> 1;
mantissa_2b_reg = mantissa_b_reg<<<1;
mantissa_4b_reg = mantissa_b_reg<<<2;
mantissa_3b= mantissa_2b_reg+{mantissa_b_reg[23],mantissa_b_reg};
end



//booth encoder

//control signals generation
logic [7:0] n, a, b, c, d;
always @* begin
case({mantissa_a_reg[2:0],1'b0})
4'b0000: begin
a[0] = 0; b[0]=0; c[0]=0; d[0]=0; n[0]=0;
end
4'b0001: begin
a[0] = 1; b[0]=0; c[0]=0; d[0]=0; n[0]=0;
end
4'b0010: begin
a[0] = 1; b[0]=0; c[0]=0; d[0]=0; n[0]=0;
end
4'b0011: begin
a[0] = 0; b[0]=1; c[0]=0; d[0]=0; n[0]=0;
end
4'b0100: begin 
a[0] = 0; b[0]=1; c[0]=0; d[0]=0; n[0]=0;
end
4'b0101: begin
a[0] = 0; b[0]=0; c[0]=1; d[0]=0; n[0]=0;
end
4'b0110: begin
a[0] = 0; b[0]=0; c[0]=1; d[0]=0; n[0]=0;
end
4'b0111: begin
a[0] = 0; b[0]=0; c[0]=0; d[0]=1; n[0]=0;
end
4'b1000: begin
a[0] = 0; b[0]=0; c[0]=0; d[0]=1; n[0]=1;
end 
4'b1001: begin
a[0] = 0; b[0]=0; c[0]=1; d[0]=0; n[0]=1;
end
4'b1010: begin
a[0] = 0; b[0]=0; c[0]=1; d[0]=0; n[0]=1;
end
4'b1011:begin
a[0] = 0; b[0]=1; c[0]=0; d[0]=0; n[0]=1;
end
4'b1100: begin
a[0] = 0; b[0]=1; c[0]=0; d[0]=0; n[0]=1;
end
4'b1101: begin
a[0] = 1; b[0]=0; c[0]=0; d[0]=0; n[0]=1;
end
4'b1110: begin
a[0] = 1; b[0]=0; c[0]=0; d[0]=0; n[0]=1;
end
4'b1111: begin
a[0] = 0; b[0]=0; c[0]=0; d[0]=0; n[0]=1;
end
default: begin
a[0] = 1; b[0]=1; c[0]=1; d[0]=1; n[0]=0;
end
endcase
 for (int i = 3; i < 24; i = i + 3) begin 
case({mantissa_a_reg[i+2],mantissa_a_reg[i+1],mantissa_a_reg[i], mantissa_a_reg[i-1]})
4'b0000: begin
a[i/3] = 0; b[i/3]=0; c[i/3]=0; d[i/3]=0; n[i/3]=0;
end
4'b0001: begin
a[i/3] = 1; b[i/3]=0; c[i/3]=0; d[i/3]=0; n[i/3]=0;
end
4'b0010: begin
a[i/3] = 1; b[i/3]=0; c[i/3]=0; d[i/3]=0; n[i/3]=0;
end
4'b0011: begin
a[i/3] = 0; b[i/3]=1; c[i/3]=0; d[i/3]=0; n[i/3]=0;
end
4'b0100: begin 
a[i/3] = 0; b[i/3]=1; c[i/3]=0; d[i/3]=0; n[i/3]=0;
end
4'b0101: begin
a[i/3] = 0; b[i/3]=0; c[i/3]=1; d[i/3]=0; n[i/3]=0;
end
4'b0110: begin
a[i/3] = 0; b[i/3]=0; c[i/3]=1; d[i/3]=0; n[i/3]=0;
end
4'b0111: begin
a[i/3] = 0; b[i/3]=0; c[i/3]=0; d[i/3]=1; n[i/3]=0;
end
4'b1000: begin
a[i/3] = 0; b[i/3]=0; c[i/3]=0; d[i/3]=1; n[i/3]=1;
end 
4'b1001: begin
a[i/3] = 0; b[i/3]=0; c[i/3]=1; d[i/3]=0; n[i/3]=1;
end
4'b1010: begin
a[i/3] = 0; b[i/3]=0; c[i/3]=1; d[i/3]=0; n[i/3]=1;
end
4'b1011:begin
a[i/3] = 0; b[i/3]=1; c[i/3]=0; d[i/3]=0; n[i/3]=1;
end
4'b1100: begin
a[i/3] = 0; b[i/3]=1; c[i/3]=0; d[i/3]=0; n[i/3]=1;
end
4'b1101: begin
a[i/3] = 1; b[i/3]=0; c[i/3]=0; d[i/3]=0; n[i/3]=1;
end
4'b1110: begin
a[i/3] = 1; b[i/3]=0; c[i/3]=0; d[i/3]=0; n[i/3]=1;
end
4'b1111: begin
a[i/3] = 0; b[i/3]=0; c[i/3]=0; d[i/3]=0; n[i/3]=1;
end
default: begin
a[i/3] = 1; b[i/3]=1; c[i/3]=1; d[i/3]=1; n[i/3]=0;
end
endcase
  end

	end


//partial product



always @* begin

for (int i=0; i<8; i++) begin
if (n[i] == 0) begin 
n_ext[i]= '0;
end
else 
if (n[i] == 1) begin
n_ext[i]= '1;
end
end
for (int i=0; i<8; i++) begin
case ({a[i], b[i], c[i], d[i]})
4'b0000: pp_booth[i]= '0; //0
4'b1000: pp_booth[i]= {mantissa_b_reg[23], mantissa_b_reg[23],mantissa_b_reg[23:0]} ^ n_ext[i]; //B
4'b0100: pp_booth[i]= {mantissa_2b_reg[24],mantissa_2b_reg[24:0]} ^ n_ext[i];//2B
4'b0010: pp_booth[i]= mantissa_3b ^ n_ext[i]; //3B
4'b0001: pp_booth[i]= mantissa_4b_reg ^ n_ext[i]; //4B
endcase
end

end

//generation m
always @* begin

for (int j=0; j<7; j++) begin

m[j][0]= pp_booth[j][0]^n[j];
m[j][1]=(pp_booth[j][1]&(~pp_booth[j][0]))|(pp_booth[j][1]&(~n[j]))|((~pp_booth[j][1])&pp_booth[j][0]&n[j]);
r[j]=pp_booth[j][1]&pp_booth[j][0]&n[j];
end
m7[0]=pp_booth[7][0]^n[7];
m7[1]=(pp_booth[7][1]&(~pp_booth[7][0]))|(pp_booth[7][1]&(~n[7]))|((~pp_booth[7][1])&pp_booth[7][0]&n[7]);
m7[2]=(pp_booth[7][2]&(~pp_booth[7][1]))|(pp_booth[7][2]&(~pp_booth[7][0]))|(pp_booth[7][2]&(~n[7]))|((~pp_booth[7][2])&pp_booth[7][1]&pp_booth[7][0]&n[7]);
m7[3]=(pp_booth[7][3]&(~pp_booth[7][2]))|(pp_booth[7][3]&(~pp_booth[7][0]))|(pp_booth[7][3]&(~n[7]))|((~pp_booth[7][3])&pp_booth[7][2]&pp_booth[7][1]&pp_booth[7][0]&n[7]);
r[7]=pp_booth[7][2]&pp_booth[7][3]&pp_booth[7][0]&pp_booth[7][1]&n[7];

end

always@* begin
q[0]= (pp_booth[0][25]|r[7]);
q[3]= ~(pp_booth[0][25]&(~r[7]));
q[1]= pp_booth[0][25]&(~r[7]);
q[2]= pp_booth[0][25]&(~r[7]);
pp0= {q[3:0], pp_booth[0][24:2], m[0][1], m[0][0]};
pp1= {'1, '1, ~(pp_booth[1][25]), pp_booth[1][24:2], m[1][1], m[1][0], r[0], 2'b0};
pp2= {'1, '1, ~(pp_booth[2][25]), pp_booth[2][24:2], m[2][1], m[2][0], r[1], 5'b0};
pp3= {'1, '1, ~(pp_booth[3][25]), pp_booth[3][24:2], m[3][1], m[3][0], r[2], 8'b0};
pp4= {'1, '1, ~(pp_booth[4][25]), pp_booth[4][24:2], m[4][1], m[4][0], r[3], 11'b0};
pp5= {'1, '1, ~(pp_booth[5][25]), pp_booth[5][24:2], m[5][1], m[5][0], r[4], 14'b0};
pp6= {'1, '1, ~(pp_booth[6][25]), pp_booth[6][24:2], m[6][1], m[6][0], r[5], 17'b0};
pp7= {'1, ~(pp_booth[7][25]), pp_booth[7][24:4], m7[3], m7[2], m7[1], m7[0], r[6], 20'b0};
end 


// partial product composition
// compression 4th level 8-5


wire [13:0] carry;
half_adder H40 (pp0[14], pp1[14], pp_3_0[14], pp_3_1[15]);
full_adder F40 (pp0[15], pp1[15], pp2[15], pp_3_0[15], pp_3_1[16]);
full_adder F41 (pp0[16], pp1[16], pp2[16], pp_3_0[16], pp_3_1[17]);
compressor_4_2 CP40 (pp0[17], pp1[17], pp2[17], pp3[17], 1'b0, carry[0], pp_3_0[17], pp_3_1[18]);
generate
for (genvar i = 0; i<11; i++) begin : blocco_compressor
compressor_4_2 CP4[i+1] (pp0[18+i], pp1[18+i], pp2[18+i], pp3[18+i], carry[i], carry[i+1], pp_3_0[18+i], pp_3_1[19+i]);
end
endgenerate
half_adder H41 (pp4[20], pp5[20], pp_3_2[20], pp_3_3[21]);
for (genvar i = 0; i<8; i++) begin
full_adder F4[i+2] (pp4[21+i], pp5[21+i], pp6[21+i], pp_3_2[21+i], pp_3_3[22+i]); 
end
compressor_4_2 CP412 (pp1[29], pp2[29], pp3[29], pp4[29], carry[11], carry[12], pp_3_0[29], pp_3_1[30]);
compressor_4_2 CP413 (pp1[30], pp2[30], pp3[30], pp4[30], carry[12], carry[13], pp_3_0[30], pp_3_1[31]);
half_adder H42 (pp5[29], pp6[29], pp_3_2[29], pp_3_3[30]);
half_adder H43 (pp5[30], pp6[30], pp_3_2[30], pp_3_3[31]);
compressor_4_2 CP414 (pp2[31], pp3[31], pp4[31], pp5[31], carry[13], pp_3_2[32], pp_3_0[31], pp_3_1[32]);
full_adder F48 (pp2[32], pp3[32], pp4[32], pp_3_0[32], pp_3_1[33]);
full_adder F49 (pp2[33], pp3[33], pp4[33], pp_3_0[33], pp_3_1[34]);
full_adder F410 (pp3[34], pp4[34], pp5[34], pp_3_0[34], pp_3_1[35]);
half_adder H44 (pp5[32], pp6[32], pp_3_3[32], pp_3_4[33]);
half_adder H45 (pp5[33], pp6[33], pp_3_2[33], pp_3_3[34]);
half_adder H46 (pp3[35], pp4[35], pp_3_0[35], pp_3_1[36]);
half_adder H47 (pp3[36], pp4[36], pp_3_0[36], pp_3_1[37]);


assign pp_3_0[13:0] = pp0[13:0];
assign pp_3_0[37]= pp4[37];
assign pp_3_1[13:0] = pp1[13:0];
assign pp_3_1[14] = pp2[14];
assign pp_3_1[39:38] =pp4[39:38];
assign pp_3_2[13:0] = pp2[13:0];
assign pp_3_2[16:14]= pp3[16:14];
assign pp_3_2[19:17]= pp4[19:17];
assign pp_3_2[31]= pp6[31];
assign pp_3_2[34]= pp6[34];
assign pp_3_2[42:35] = pp5[42:35];
assign pp_3_3[13:0] = pp3[13:0];
assign pp_3_3[16:14] = pp4[16:14];
assign pp_3_3[19:17] = pp5 [19:17];
assign pp_3_3[20]= pp6[20];
assign pp_3_3[33]= pp7[33];
assign pp_3_3[45:35] = pp6[45:35];
assign pp_3_4[13:0] = pp4[13:0];
assign pp_3_4[16:14] = pp5[16:14];
assign pp_3_4[19:17] = pp6[19:17];
assign pp_3_4[32:20] = pp7[32:20];
assign pp_3_4[47:34] = pp7[47:34];



wire [27:0] carry_i;

half_adder H30 (pp_3_0[8], pp_3_1[8], pp_2_0[8], pp_2_1[9]);
full_adder F30 (pp_3_0[9], pp_3_1[9], pp_3_2[9], pp_2_0[9], pp_2_1[10]);
full_adder F31 (pp_3_0[10], pp_3_1[10], pp_3_2[10], pp_2_0[10], pp_2_1[11]);
compressor_4_2 CP30 (pp_3_0[11], pp_3_1[11], pp_3_2[11], pp_3_3[11], 1'b0, carry_i[0], pp_2_0[11], pp_2_1[12]);
for (genvar i = 0; i<26; i++) begin
compressor_4_2 CP3[i+1] (pp_3_0[12+i], pp_3_1[12+i], pp_3_2[12+i], pp_3_3[12+i], carry_i[i], carry_i[1+i], pp_2_0[12+i], pp_2_1[13+i]);
end
full_adder F32 (pp_3_1[38], pp_3_2[38], carry_i[26], pp_2_0[38], pp_2_1[39]);
half_adder H31 (pp_3_3[38], pp_3_4[38], pp_2_2[38], pp_2_2[39]);
compressor_4_2 CP327 (pp_3_1[39], pp_3_2[39], pp_3_3[39], pp_3_4[39], 1'b0, carry_i[27], pp_2_0[39], pp_2_1[40]);
full_adder F33 (carry_i[27], pp_3_2[40], pp_3_3[40], pp_2_0[40], pp_2_1[41]);
half_adder H32 (pp_3_2[41], pp_3_3[41], pp_2_0[41], pp_2_1[42]);
half_adder H33 (pp_3_2[42], pp_3_3[42], pp_2_0[42], pp_2_1[43]);



assign pp_2_0[7:0] = pp_3_0[7:0];
assign pp_2_0[43] = pp_3_3[43];
assign pp_2_1[7:0] = pp_3_1[7:0];
assign pp_2_1[8] = pp_3_2[8];
assign pp_2_1[45:44] = pp_3_3[45:44];
assign pp_2_2[7:0] = pp_3_2[7:0];
assign pp_2_2[10:8] = pp_3_3[10:8];
assign pp_2_2[37:11] = pp_3_4[37:11];
assign pp_2_2[47:40] = pp_3_4[47:40];


half_adder H20 (pp_2_0[5], pp_2_1[5], pp_1_0[5], pp_1_1[6]);

for (genvar i = 0; i<38; i++) begin
full_adder F2[i+1] (pp_2_0[6+i], pp_2_1[6+i], pp_2_2[6+i], pp_1_0[6+i], pp_1_1[7+i]);
end
half_adder H21 (pp_2_1[44], pp_2_2[44], pp_1_0[44], pp_1_1[45]);
half_adder H22 (pp_2_1[45], pp_2_2[45], pp_1_0[45], pp_1_1[46]);




assign pp_1_0[4:0] = pp_2_0[4:0];
assign pp_1_0[46] = pp_2_2[46];
assign pp_1_1[4:0] = pp_2_1[4:0];
assign pp_1_1[5] = pp_2_2[5];
assign pp_1_1[47] = pp_2_2[47];

assign product = (pp_1_1+ pp_1_0)<<2;

endmodule
