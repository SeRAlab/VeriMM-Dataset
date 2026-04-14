module top_module(output [3:0] s0,
output [3:0] s1,
output [3:0] s2,
output [3:0] s3,
output [3:0] s4,
output [3:0] s5,
output [3:0] s6,
output [21:0] s7,
input [3:0] a, 
input [3:0] b);assign s0 = ~a;
assign s1 = (a | b);
assign s2 = ~(a | b);
assign s3 = (a & b);
assign s4 = ~(a & b);
assign s5 = (a ^ b);
assign s6 = ~(a ^ b);
assign s7 = (s0 & s1 & s2 & s3 & s4 & s5 & s6);endmodule