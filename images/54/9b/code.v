module top_module(
  input [n-1:0] in,
  input enable,
  output [n-1:0] out
);parameter n = 8; // number of bits in the bus

reg [n-1:0] latch;

always @ (posedge enable) begin
  if (enable) begin
    latch <= in;
  end
end

assign out = enable ? latch : out;

endmodule