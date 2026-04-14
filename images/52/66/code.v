module top_module(
  input clk,
  input rst,
  input [n-1:0] in,
  output reg [n-1:0] out
);parameter n = 8; // number of bits in the accumulator
parameter m = 10; // number of clock cycles over which the accumulator will sum the inputs

reg [n-1:0] sum;

always @(posedge clk) begin
  if (rst) begin
    sum <= 0;
  end else begin
    sum <= sum + in;
  end
end

assign out = sum;

endmodule