module top_module(clk, en, enclk, te);input clk;
  input en;
  input te;
  output enclk;

  reg gated_clk;

  always @(posedge clk) begin
    if (en) begin
      if (te) begin
        gated_clk <= 1'b1;
      end else begin
        gated_clk <= 1'b0;
      end
    end else begin
      gated_clk <= 1'b0;
    end
  end

  assign enclk = gated_clk & clk;

endmodule