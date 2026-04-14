module top_module(
    input [31:0] in_signal,
    output [15:0] out_signal
);wire [15:0] first_16_bits;
    wire [15:0] last_16_bits;

    assign first_16_bits = in_signal[31:16];
    assign last_16_bits = in_signal[15:0];

    assign out_signal = first_16_bits + last_16_bits;

endmodule