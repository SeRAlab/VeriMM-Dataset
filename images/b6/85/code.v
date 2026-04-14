module top_module(
  input [(16 - 1):0] in0,
  input [(16 - 1):0] in1,
  output [(32 - 1):0] y,
  input clk,
  input ce,
  input clr);reg [(16 - 1):0] in0_reg;
  reg [(16 - 1):0] in1_reg;
  reg [(32 - 1):0] y_reg;
  
  always @(posedge clk) begin
    if (clr) begin
      in0_reg <= 0;
      in1_reg <= 0;
      y_reg <= 0;
    end else if (ce) begin
      in0_reg <= in0;
      in1_reg <= in1;
      y_reg <= {in0, in1};
    end
  end
  
  assign y = y_reg;
  
endmodule