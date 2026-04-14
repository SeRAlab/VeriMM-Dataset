module top_module(
  input CLK,
  input EN,
  input TE,
  output reg ENCLK
);wire gated_clk;

  assign gated_clk = (EN == 1'b1) ? CLK : 1'b0;

  always @(posedge gated_clk) begin
    if (TE == 1'b1) begin
      ENCLK <= 1'b0;
    end else begin
      ENCLK <= EN ? 1'b1 : ENCLK;
    end
  end

endmodule