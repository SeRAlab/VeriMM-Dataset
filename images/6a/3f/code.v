module top_module(
  input reset,
  input clk,
  input in,
  output out
);reg out_reg;

  always @(posedge clk or negedge reset) begin
    if (!reset) begin
      out_reg <= 0;
    end else begin
      out_reg <= in;
    end
  end

  assign out = out_reg;

endmodule