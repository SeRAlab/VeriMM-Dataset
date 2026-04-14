module top_module(
    input [15:0] in,
    input [3:0] shift,
    output [15:0] out
);assign out = (shift >= 0) ? (in << shift) : (in >> -shift);

endmodule