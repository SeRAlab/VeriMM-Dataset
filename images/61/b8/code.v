module top_module(
  input clk,
  input rst,
  input [n-1:0] in,
  output reg out
);parameter n = 4; // number of input signals

reg [31:0] sum; // register to store the sum of input signals

always @(posedge clk) begin
  if (rst) begin
    sum <= 0;
  end else begin
    sum <= sum + in;
  end
end

assign out = sum;

endmodule