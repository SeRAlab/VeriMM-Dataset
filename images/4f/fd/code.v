module top_module(
    input wire a,
    input wire b,
    input wire c,
    output wire out
);

    assign out = (a & b) | (a & c) | (b & c);

endmodule