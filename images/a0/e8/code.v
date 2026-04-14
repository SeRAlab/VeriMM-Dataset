module top_module(
  input [n-1:0] in,
  output reg [m-1:0] out
);parameter n = 4; // number of input signals
parameter m = 2; // number of output signals

reg [n-1:0] latch;

always @ (in) begin
  latch <= in;
end

assign out = latch & ((1 << m) - 1);

endmodule