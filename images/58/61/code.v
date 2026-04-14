module top_module(
  input clk,
  input rst,
  input [n-1:0] data_in,
  output reg [n-1:0] acc_out
);parameter n = 8; // number of bits in the accumulator
parameter max_value = 255; // maximum value that can be accumulated without overflow

reg [n-1:0] sum; // register to store the accumulated sum

always @(posedge clk) begin
  if (rst) begin
    sum <= 0; // clear the accumulated sum to zero
  end else begin
    sum <= (sum + data_in) > max_value ? max_value : (sum + data_in); // add the input value to the accumulated sum and check for overflow
  end
end

assign acc_out = sum; // provide the accumulated sum as output

endmodule