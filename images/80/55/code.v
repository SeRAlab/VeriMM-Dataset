module top_module(
  input [1:0] A,
  input [1:0] B,
  output reg Y
);always @(*) begin
    if (A[1] == B[1]) begin
      if (A[0] >= B[0]) begin
        Y = 1;
      end else begin
        Y = 0;
      end
    end else begin
      if (A[1] > B[1]) begin
        Y = 1;
      end else begin
        Y = 0;
      end
    end
  end

endmodule