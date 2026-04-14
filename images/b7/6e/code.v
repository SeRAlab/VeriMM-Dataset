module top_module(
  input clk,
  input [7:0] data_in,
  output reg [7:0] data_out,
  output reg [7:0] data_out_inv
);always @(posedge clk) begin
    data_out <= data_in;
  end

  always @(negedge clk) begin
    data_out_inv <= ~data_in;
  end

endmodule