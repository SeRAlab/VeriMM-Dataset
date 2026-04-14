module top_module(
  input clk,
  input rst,
  input [7:0] data_in,
  input valid_in,
  input [15:0] checksum_in,
  output [15:0] checksum,
  output valid_out
);reg [7:0] data_reg;
  reg [15:0] sum_reg;
  reg [15:0] checksum_reg;
  reg [3:0] count_reg;
  reg [15:0] temp_reg;

  always @(posedge clk) begin
    if (rst) begin
      data_reg <= 8'h00;
      sum_reg <= 16'h0000;
      checksum_reg <= 16'h0000;
      count_reg <= 4'h0;
      temp_reg <= 16'h0000;
    end else begin
      if (valid_in) begin
        data_reg <= data_in;
        sum_reg <= sum_reg + data_reg;
        checksum_reg <= checksum_in;
        count_reg <= count_reg + 4'h1;
      end
      if (count_reg == 4'h9) begin  // Changed condition to 4'h9 to account for 10 total counts (0-9)
        temp_reg <= checksum_reg + sum_reg;
        sum_reg <= temp_reg;
        checksum_reg <= sum_reg;
        count_reg <= 4'h0;
      end
    end
  end

  assign checksum = checksum_reg;
  assign valid_out = (checksum_reg == checksum_in);

endmodule