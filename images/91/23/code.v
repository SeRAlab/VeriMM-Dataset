module top_module(
    input [7:0] R_in,
    input [7:0] G_in,
    input [7:0] B_in,
    output [7:0] R_out,
    output [7:0] G_out,
    output [7:0] B_out
);assign R_out = R_in - G_in;
    assign G_out = G_in + B_in;
    assign B_out = B_in - R_in;

endmodule