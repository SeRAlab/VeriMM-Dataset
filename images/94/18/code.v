module top_module(
  input [3:0] voltage,
  input clk,
  output [3:0] speed,
  output warning
);reg [3:0] speed_reg;
  reg warning_reg;

  always @(posedge clk) begin
    if (voltage < 4) begin
      speed_reg <= 4'b0000;
      warning_reg <= 1'b0;
    end else if (voltage >= 4 && voltage < 6) begin
      speed_reg <= 4'b0100;
      warning_reg <= 1'b0;
    end else if (voltage >= 6 && voltage < 8) begin
      speed_reg <= 4'b1111;
      warning_reg <= 1'b0;
    end else begin
      speed_reg <= 4'b1111;
      warning_reg <= 1'b1;
    end
  end

  assign speed = speed_reg;
  assign warning = warning_reg;

endmodule