module top_module(
  input [n-1:0] in,
  output [m-1:0] out
);parameter n = 4; // number of input signals
parameter m = 2; // number of output signals
parameter v1 = 1.8; // voltage level of the input signals
parameter v2 = 3.3; // voltage level of the output signals

// Voltage level shifter circuit
wire [n-1:0] shifted;
genvar i;
generate
  for (i = 0; i < n; i = i + 1) begin : shifter
    assign shifted[i] = (in[i] == 1'b1) ? (v2 / v1) : 1'b0;
  end
endgenerate

// Connect the shifted signals to the output signals
assign out = shifted[m-1:0];

endmodule