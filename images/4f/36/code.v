module top_module(G, B, clk, rst);output [3:0] G;
  input [3:0] B;
  input clk, rst;

  reg [3:0] G_reg;
  reg [3:0] B_reg;

  always @(posedge clk, negedge rst) begin
    if (~rst) begin
      G_reg <= 4'b0;
      B_reg <= 4'b0;
    end else begin
      B_reg <= B;
      G_reg <= {B_reg[3], B_reg[3]^B_reg[2], B_reg[2]^B_reg[1], B_reg[1]^B_reg[0]};
    end
  end

  assign G = G_reg;

endmodule