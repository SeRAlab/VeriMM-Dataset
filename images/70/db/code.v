module top_module(
  input signed [3:0] multiplier,
  input signed [3:0] multiplicand,
  input clock,
  input reset,
  output signed [7:0] product
);reg signed [7:0] product_reg;
  reg signed [3:0] multiplier_reg;
  reg signed [3:0] multiplicand_reg;
  reg signed [3:0] multiplier_shifted;
  
  always @(posedge clock) begin
    if (reset) begin
      product_reg <= 8'b0;
      multiplier_reg <= multiplier;
      multiplicand_reg <= multiplicand;
    end else begin
      multiplier_shifted <= {multiplier_reg[3], multiplier_reg};
      case ({multiplier_shifted[3], multiplier_shifted[2]})
        2'b01: product_reg <= product_reg + multiplicand_reg;
        2'b10: product_reg <= product_reg - multiplicand_reg;
      endcase
      product_reg <= {product_reg[6:0], product_reg[7]};
      multiplier_reg <= multiplier_shifted;
    end
  end
  
  assign product = product_reg;

endmodule