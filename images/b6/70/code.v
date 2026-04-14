module top_module(
    input [47:0] e,
    input [47:0] k,
    output [5:0] b1x,
    output [5:0] b2x,
    output [5:0] b3x,
    output [5:0] b4x,
    output [5:0] b5x,
    output [5:0] b6x,
    output [5:0] b7x,
    output [5:0] b8x
);wire [47:0] XX;

assign XX = k ^ e;
assign b1x = XX[5:0];
assign b2x = XX[11:6];
assign b3x = XX[17:12];
assign b4x = XX[23:18];
assign b5x = XX[29:24];
assign b6x = XX[35:30];
assign b7x = XX[41:36];
assign b8x = XX[47:42];

endmodule