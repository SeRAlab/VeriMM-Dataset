module top_module(a, b, out, carry);parameter n = 3;
input signed [n:0] a;
input signed [n:0] b;
output signed [n:0] out;
output carry;
assign {carry, out} = a - b;
endmodule