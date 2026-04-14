module top_module(
  input clk,
  input rst,
  input [n-1:0] in,
  output reg [n-1:0] out
);parameter n = 8; // number of bits in the input and output signals

reg [n-1:0] sum; // register to store the accumulated sum

always @(posedge clk) begin
  if (rst) begin
    sum <= 0; // reset the accumulated sum to zero
  end else begin
    sum <= sum + in; // add the input signal to the accumulated sum
  end
end

assign out = rst ? 0 : sum; // select between the accumulated sum and zero based on the reset signal

endmodule