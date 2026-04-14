module top_module(
  input [n-1:0] in,
  input [n-1:0] priority_bits,
  output out
);parameter n = 4; // number of binary signals

wire [n-1:0] priority_encoded;
wire [n-1:0] priority_sorted;
wire [n-1:0] priority_mask;
wire [n-1:0] priority_masked;

assign priority_encoded = ~(in ^ priority_bits);
assign priority_sorted = {priority_encoded[n-1], priority_encoded[n-2:0]};
assign priority_mask = {priority_sorted[n-1] & priority_sorted[n-2:0], priority_sorted[n-2] & priority_sorted[n-3:0], priority_sorted[n-3] & priority_sorted[n-4:0], priority_sorted[n-4]};
assign priority_masked = priority_encoded & priority_mask;

assign out = $onehot0(priority_masked);

endmodule