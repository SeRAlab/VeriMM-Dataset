module top_module(
  output out
);parameter n = 3; // number of NOT gates in the ring oscillator

wire [n-1:0] not_outputs;
wire feedback;

assign not_outputs[0] = ~feedback;

genvar i;
generate
  for (i = 1; i < n; i = i + 1) begin
    assign not_outputs[i] = ~not_outputs[i-1];
  end
endgenerate

assign feedback = not_outputs[n-1];

assign out = not_outputs[n-1];

endmodule