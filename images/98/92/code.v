module top_module(
  input clk,
  input en,
  input te,
  output reg enclk
);always @ (posedge clk) begin
    if (te == 0 || en == 1) begin
      enclk <= clk;
    end else begin
      enclk <= 0;
    end
  end

endmodule