module top_module(
  input CLK,
  input SLOWCLK,
  input RESET,
  output reg EN_OUT
);reg [1:0] cur;
  reg [1:0] slowclk_last;

  always @(posedge CLK) begin
    if (RESET) begin
      EN_OUT <= 1'b0;
      cur <= 2'b0;
      slowclk_last <= 2'b0;
    end else begin
      if (SLOWCLK == slowclk_last) begin
        cur <= ~cur;
        EN_OUT <= 1'b1;
      end else begin
        EN_OUT <= 1'b0;
      end
      slowclk_last <= SLOWCLK;
    end
  end

endmodule