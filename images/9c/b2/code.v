module top_module(
  input input_signal_1,
  input input_signal_2,
  input input_signal_3,
  input input_signal_4,
  input input_signal_5,
  output output_signal
);assign output_signal = ((input_signal_1 & ~input_signal_2) | (~input_signal_3 & input_signal_4) | (input_signal_5 ^ (input_signal_1 & input_signal_2 & input_signal_3 & input_signal_4)));

endmodule