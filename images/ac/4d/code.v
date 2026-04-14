module top_module(
    input [3:0] a,
    input [3:0] b,
    input [3:0] c,
    output reg [3:0] s,
    output reg [3:0] c_out
);wire [3:0] x, y, z, carry1, carry2;

assign x = a ^ b;
assign y = a & b;
assign z = x & c;
assign carry1 = y | z;
assign carry2 = (a & b) | (c & x);

assign s = x ^ c;
assign c_out = carry1 | carry2;

endmodule