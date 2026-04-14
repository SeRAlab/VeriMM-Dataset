module top_module(
  input clk,
  input [3:0] a,
  input [3:0] b,
  output [7:0] result
);reg [7:0] product_reg;   // register to hold the product
  reg [3:0] a_reg;         // register to hold a
  reg [3:0] b_reg;         // register to hold b

  always @(posedge clk) begin
    a_reg <= a;
    b_reg <= b;
    product_reg <= a_reg * b_reg;   // multiply a and b and store in product_reg
  end

  assign result = product_reg;   // assign the product to the output

endmodule