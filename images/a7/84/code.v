module top_module(A,
    B,
    P);input [11:0] A;
  input [13:0] B;
  output reg [32:0] P;

  always @(*) begin
    P = A * B; // Simple multiplication
  end
endmodule