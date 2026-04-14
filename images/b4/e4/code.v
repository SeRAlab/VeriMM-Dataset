module top_module(
  input clk,
  input en,
  input enclk,
  input d,
  output q
);reg q_reg;

  always @(posedge clk) begin
    if (en && enclk) begin
      q_reg <= d;
    end
  end

  assign q = (en) ? q_reg : q;

endmodule