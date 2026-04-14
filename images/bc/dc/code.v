module top_module(
    in,
    out
);input [31:0] in;
    output [15:0] out;

    assign out[15:0] = in[15:0];

endmodule