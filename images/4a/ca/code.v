module top_module(
    input [31:0] signal_in,
    output [63:0] signal_out
    );assign signal_out = signal_in * 2;

endmodule