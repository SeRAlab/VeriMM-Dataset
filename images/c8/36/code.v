module split_bytes (
 input [7:0] input_signal,
 output [3:0] output_signal_1,
 output [3:0] output_signal_2
);

 assign output_signal_1 = input_signal[7:4];
 assign output_signal_2 = input_signal[3:0];

endmodule