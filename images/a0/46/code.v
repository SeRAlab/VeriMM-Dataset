module top_module(
  input [7:0] A,
  input [7:0] B,
  output reg [7:0] C
);always @(*) begin
    C[0] = A[0] ^ B[0];
    C[1] = A[1] ^ B[1];
    C[2] = A[2] ^ B[2];
    C[3] = A[3] ^ B[3];
    C[4] = A[4] ^ B[4];
    C[5] = A[5] ^ B[5];
    C[6] = A[6] ^ B[6];
    C[7] = A[7] ^ B[7];
  end

endmodule