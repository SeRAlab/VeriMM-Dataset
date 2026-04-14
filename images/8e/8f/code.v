module top_module(
  input clk,
  input rst,
  input en,
  input en_carry,
  input [3:0] A,
  input [3:0] B,
  input Cin,
  output [3:0] S,
  output Cout
);reg [3:0] S_reg;
  reg Cout_reg;

  always @(posedge clk, posedge rst) begin
    if (rst) begin
      S_reg <= 4'b0;
      Cout_reg <= 1'b0;
    end else if (en) begin
      S_reg <= A + B + Cin;
      Cout_reg <= (S_reg[4] || (en_carry && (S_reg == 4'hF)));
    end
  end

  assign S = S_reg;
  assign Cout = Cout_reg;
endmodule