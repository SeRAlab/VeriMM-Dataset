module top_module(
    input [2:0] in,
    output [7:0] out
);

    // Assign the output based on the input signal
    assign out = 1 << in;

endmodule