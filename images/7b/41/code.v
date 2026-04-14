module top_module(
  input in,
  output out
);parameter v1 = 1.8; // voltage level of the input signal
parameter v2 = 3.3; // voltage level of the output signal

// Define the level shifting circuit using logic gates and resistors
wire intermediate_signal;
assign intermediate_signal = (in == 1'b1) ? v2 : v1;

// Connect the input signal to the level shifting circuit and the level shifting circuit to the output signal
assign out = intermediate_signal;

endmodule