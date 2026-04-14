module top_module(
  input in,
  input [n-1:0] ctl,
  output [2**n-1:0] out
);parameter n = 3; // number of control signals

// Define the Boolean functions for routing the input signal to the output signals based on the control signals
generate
  genvar i;
  for (i = 0; i < 2**n; i = i + 1) begin : routing_logic
    assign out[i] = (ctl == i) ? in : 0;
  end
endgenerate

endmodule