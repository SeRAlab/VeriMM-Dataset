module top_module(
  input [7:0] data_in,
  input reset,
  input clk,              // Added clk input
  output [15:0] checksum_out,
  output valid
);reg [15:0] checksum_reg;
  reg valid_reg;
  
  always @(posedge clk) begin
    if (reset) begin
      checksum_reg <= 16'h0000;
      valid_reg <= 1'b0;
    end else begin
      checksum_reg <= ~(checksum_reg + data_in);
      valid_reg <= (checksum_reg == checksum_out);
    end
  end
  
  assign checksum_out = checksum_reg;
  assign valid = valid_reg;
  
endmodule