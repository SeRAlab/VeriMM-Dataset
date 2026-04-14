module top_module(
  input clk,
  input rst_n,
  input [31:0] a,
  input [31:0] b,
  input sub,
  output reg rise,
  output reg [31:0] sum
);reg [31:0] a_reg, b_reg;
  reg [31:0] a_dif, b_dif;
  reg [31:0] sum_add, sum_sub;
  wire [31:0] xor_out;
  wire [31:0] carry_out;

  assign xor_out = a_dif ^ b_dif;
  assign carry_out = a_dif & b_dif;

  always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
      a_reg <= 0;
      b_reg <= 0;
      rise <= 0;
      sum <= 0;
    end else begin
      a_reg <= a;
      b_reg <= b;
      a_dif <= a_reg ^ {1'b0, a_reg[31:1]};
      b_dif <= b_reg ^ {1'b0, b_reg[31:1]};
      sum_add <= a_reg + b_reg;
      sum_sub <= a_reg - b_reg;
      if (sub) begin
        sum <= sum_sub;
      end else begin
        sum <= sum_add;
      end
      if (a_dif[0] & b_dif[0]) begin
        rise <= 0;
      end else if (~a_dif[0] & b_dif[0]) begin
        rise <= 1;
      end else if (a_dif[0] & ~b_dif[0]) begin
        rise <= 1;
      end else begin
        rise <= 0;
      end
    end
  end

endmodule