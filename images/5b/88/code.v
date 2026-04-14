module top_module(
    B,
    G
);input [7:0] B;
output [7:0] G;
wire [7:0] G;




assign G = ((B >>> 1) ^ B);

endmodule