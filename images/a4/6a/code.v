module top_module(
  input [bits-1:0] din,
  output analog_out
);parameter bits = 8; // number of bits in the digital input signal
parameter vref = 5; // reference voltage for the analog output signal

assign analog_out = (din / (2**bits - 1)) * vref;

endmodule