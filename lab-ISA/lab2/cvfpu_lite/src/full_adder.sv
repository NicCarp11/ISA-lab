module full_adder(a, b, carry_in, sum, carry_out);

input logic a;
input logic carry_in;
input logic b;

output logic sum;

output logic carry_out;
always@(a, b, carry_in) begin
sum = (a^b)^carry_in;
carry_out = (a&b) | (a&carry_in) |(b&carry_in);
end
endmodule
