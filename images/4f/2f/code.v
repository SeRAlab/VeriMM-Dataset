module top_module(
  input clk,
  input en,
  output reg enclk
);reg d;

  always @(posedge clk) begin
    if (en) begin
      d <= 1'b1;
      enclk <= 1'b1;
    end else begin
      d <= 1'b0;
      enclk <= 1'b0;
    end
  end

endmodule