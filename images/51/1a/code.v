module top_module(
  input signed [7:0] A,
  input signed [7:0] B,
  input [1:0] op,
  output reg signed [7:0] C,
  output reg ovf,
  output reg div0
);always @(*) begin
    case (op)
      2'b00: C = A + B;
      2'b01: C = A - B;
      2'b10: C = A * B;
      2'b11: begin
        if (B == 0) begin
          C = 8'b0;
          div0 = 1;
        end else begin
          C = A / B;
          div0 = 0;
        end
      end
    endcase

    if ((C[7] == 1 && op == 2'b00 && B[7] == 1 && A[7] == 1) ||
        (C[7] == 0 && op == 2'b01 && B[7] == 1 && A[7] == 0) ||
        (C[7] == 0 && op == 2'b10 && B[7] == 1 && A[7] == 1) ||
        (C == 8'b0 && op == 2'b11)) begin
      ovf = 1;
    end else begin
      ovf = 0;
    end
  end

endmodule