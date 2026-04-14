module top_module(
    in,
    out
);input [3:0] in;
    output [3:0] out;

    wire a, b, c, d;

    // Reverse the bits
    assign a = in[0] & ~in[1] & ~in[2] & ~in[3];
    assign b = ~in[0] & in[1] & ~in[2] & ~in[3];
    assign c = ~in[0] & ~in[1] & in[2] & ~in[3];
    assign d = ~in[0] & ~in[1] & ~in[2] & in[3];

    // Output the reversed bits
    assign out = {d, c, b, a};

endmodule