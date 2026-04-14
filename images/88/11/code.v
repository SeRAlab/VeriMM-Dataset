module top_module(
  input clk,
  input [7:0] data_in,
  output reg [31:0] sum_out
);always @(posedge clk) begin
    sum_out <= sum_out + data_in;
  end

endmodule