module top_module(
  input [(1 - 1):0] ip,
  output [(1 - 1):0] op,
  input clk,
  input ce,
  input clr);reg [(1 - 1):0] op_reg;

  always @(posedge clk) begin
    if (ce) begin
      op_reg <= ~ip;
    end
  end

  assign op = clr ? 1'b0 : op_reg;

endmodule