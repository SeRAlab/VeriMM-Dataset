module top_module(
  input clk,
  input rst,
  input [7:0] data_in,
  input valid_in,
  output [7:0] checksum_out,
  output valid_out
);reg [15:0] sum;
  reg [7:0] checksum;
  reg valid_out_reg;

  always @(posedge clk) begin
    if (rst) begin
      sum <= 0;
      checksum <= 0;
      valid_out_reg <= 0;
    end else if (valid_in) begin
      sum <= sum + data_in;
      checksum <= ~sum[15:8] - sum[7:0] - 1;
      valid_out_reg <= 1;
    end else begin
      valid_out_reg <= 0;
    end
  end

  assign checksum_out = checksum;
  assign valid_out = valid_out_reg;

endmodule