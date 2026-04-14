module top_module(
  input clk,
  input [3:0] A,
  input [3:0] B,
  input Cin,
  output [3:0] S,
  output Cout
);reg [3:0] sum;
  reg Cout_reg;

  always @(posedge clk) begin
    sum <= A + B + Cin;
    Cout_reg <= (A[3] & B[3]) | (A[3] & Cin) | (B[3] & Cin);
  end

  assign S = sum;
  assign Cout = Cout_reg;

endmodule