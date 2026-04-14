module top_module(
  input [1:0] a,
  input [1:0] b,
  output [0:0] op,
  input clk,
  input ce,
  input clr
);reg [1:0] a_reg;
  reg [1:0] b_reg;
  reg [0:0] op_reg;

  always @(posedge clk) begin
    if (ce) begin
      a_reg <= a;
      b_reg <= b;
      op_reg <= (a == b) ? 1'b1 : 1'b0;
    end
  end

  assign op = op_reg;

  always @(posedge clk) begin
    if (clr) begin
      a_reg <= 2'b0;
      b_reg <= 2'b0;
      op_reg <= 1'b0;
    end
  end

endmodule