module top_module(
  input [(16 - 1):0] in0,
  input [(16 - 1):0] in1,
  output [(32 - 1):0] y,
  input clk,
  input ce,
  input clr
);reg [(32 - 1):0] y_reg;

  always @(posedge clk) begin
    if (clr) begin
      y_reg <= 0;
    end else if (ce) begin
      y_reg <= {in0, in1};
    end
  end

  assign y = y_reg;

endmodule