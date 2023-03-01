`include "full_adder.sv"
module compressor_4_2(a, b, c, d, cin, cout, sum_i, sum_i1);
input logic a;
input logic b;
input logic c;
input logic d;
input logic cin;
wire s1;
output logic cout, sum_i, sum_i1;


full_adder FL1( .a(a),
				.b(b),
				.carry_in(c),
				.sum(s1),
				.carry_out(cout));

full_adder FL2( .a(s1),
				.b(d),
				.carry_in(cin),
				.sum(sum_i),
				.carry_out(sum_i1));


endmodule
