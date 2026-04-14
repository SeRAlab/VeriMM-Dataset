module top_module(
    input [31:0] input_signal,
    output [21:0] output_upper,
    output [9:0] output_lower
);assign output_upper = input_signal[31:10];
assign output_lower = input_signal[9:0];

endmodule