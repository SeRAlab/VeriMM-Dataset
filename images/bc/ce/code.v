module top_module(
  input        clk,
  input        rst,
  input  [31:0] data_in,
  output [15:0] data_out
);reg     [31:0] data_reg;
  reg     [15:0] data_out_reg;
  parameter      multiplier = 3;

  always @(posedge clk) begin
    if (rst == 1'b0) begin
      data_out_reg <= 16'b0;
    end else begin
      data_reg <= data_in;
      data_out_reg <= multiplier * data_reg[15:0];
    end
  end

  assign data_out = data_out_reg;

endmodule