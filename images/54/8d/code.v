module top_module(
    input [7:0] X,
    input [7:0] Y,
    output [7:0] CHAR,
    output [7:0] ATTR
    );assign CHAR = 64 + X + Y;
assign ATTR = { X[3:0], Y[3:0] };

endmodule