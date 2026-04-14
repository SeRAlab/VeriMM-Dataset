module top_module(
    input [3:0] a,
    input [3:0] b,
    output [3:0] out_xor_bitwise,
    output out_xor_logical,
    output [7:0] out_not
);wire [3:0] a_not;
wire [3:0] b_not;

assign a_not = ~a;
assign b_not = ~b;

assign out_not = {b_not, a_not};

assign out_xor_bitwise = (a & ~b) | (~a & b);

assign out_xor_logical = a ^ b;

endmodule