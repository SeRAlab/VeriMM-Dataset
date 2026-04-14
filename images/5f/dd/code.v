module top_module(
  input clk,
  input reset,
  input [3:0] a,
  input [3:0] b,
  output reg [3:0] sum,
  output reg carry,
  output reg [2:0] count,
  output reg [3:0] so
);reg [3:0] a_reg, b_reg;
  reg [1:0] sum_reg;
  reg carry_reg;
  
  always @(posedge clk) begin
    if (reset) begin
      a_reg <= 4'b0;
      b_reg <= 4'b0;
      sum_reg <= 2'b0;
      carry_reg <= 1'b0;
      sum <= 4'b0;
      carry <= 1'b0;
      count <= 3'b0;
      so <= 4'b0;
    end else begin
      a_reg <= {a_reg[2:0], a};
      b_reg <= {b_reg[2:0], b};
      sum_reg <= {sum_reg[0], a_reg[0] ^ b_reg[0]};
      carry_reg <= a_reg[0] & b_reg[0];
      sum <= {sum_reg[1], sum_reg[0], a_reg[1:0] ^ b_reg[1:0]};
      carry <= carry_reg | (sum_reg[1] & carry_reg);
      count <= count + 1;
      so <= {sum_reg, a_reg[2]};
    end
  end
  
endmodule