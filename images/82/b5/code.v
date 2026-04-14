module top_module(
  input in,
  input [n-1:0] sel,
  output [2**n-1:0] out
);parameter n = 3; // number of select signals

assign out[0] = (sel == 0) ? in : 1'b0; // If all select signals are zero, route input signal to out[0]
assign out[2**n-1] = (sel == (2**n-1)) ? in : 1'b0; // If all select signals are one, route input signal to out[2^n-1]

// For all other combinations of select signals, route input signal to the corresponding output signal
genvar i;
generate
  for (i = 0; i < 2**n; i = i + 1) begin : DEMUX_GEN
    assign out[i] = (sel == i) ? in : 1'b0;
  end
endgenerate

endmodule