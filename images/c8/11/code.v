module complement(input [3:0] A, output reg [3:0] B);

  always @(*) begin
    B[0] = ~A[0];
    B[1] = ~A[1];
    B[2] = ~A[2];
    B[3] = ~A[3];
  end

endmodule