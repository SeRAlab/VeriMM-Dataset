module top_module(
  output [(1 - 1):0] op,
  input clk,
  input ce,
  input clr
);reg [(1 - 1):0] op_reg;
  
  always @(posedge clk) begin
    if (clr) begin
      op_reg <= 1'b0;
    end else if (ce) begin
      op_reg <= 1'b1;
    end
  end
  
  assign op = op_reg;
endmodule