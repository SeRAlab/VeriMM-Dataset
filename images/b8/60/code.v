module top_module(
  input data_in,
  input clk_in,
  input reset_in,
  output reg data_out,
  output reg clk_out,
  output reg reset_out
);reg data_sync1;
reg data_sync2;
reg reset_sync;

always @(posedge clk_in) begin
  data_sync1 <= data_in;
end

always @(posedge clk_out) begin
  data_sync2 <= data_sync1;
  data_out <= data_sync2;
end

always @(posedge clk_out) begin
  reset_sync <= reset_in;
  reset_out <= reset_sync;
end

assign clk_out = clk_in;

endmodule