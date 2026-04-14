module top_module(
  input [(8 - 1):0] a,
  input [(8 - 1):0] b,
  output [(1 - 1):0] op,
  input clk,
  input ce,
  input clr
);reg [(1 - 1):0] op_reg;
  wire [(8 - 1):0] a_reg;
  wire [(8 - 1):0] b_reg;

  assign a_reg = a;
  assign b_reg = b;

  always @(posedge clk) begin
    if (clr) begin
      op_reg <= 1'b0;
    end else if (ce) begin
      op_reg <= (a_reg == b_reg) ? 1'b1 : 1'b0;
    end
  end

  assign op = op_reg;

endmodule