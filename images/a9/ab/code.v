module top_module(
  input [3:0] A,
  input [3:0] B,
  output reg [3:0] S,
  output reg C
);always @* begin
    S = A + B;
    C = (S[3] == 1);
  end

endmodule