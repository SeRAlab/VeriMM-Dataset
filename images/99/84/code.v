module top_module(A, B, op, Y);input [15:0] A, B;
  input [3:0] op;
  output reg [15:0] Y;  // Changed wire to reg

  wire [15:0] notA, notB, shiftLeft, shiftRight, rotateLeft, rotateRight;

  assign notA = ~A;
  assign notB = ~B;
  assign shiftLeft = {A[14:0], 1'b0};
  assign shiftRight = {1'b0, A[15:1]};
  assign rotateLeft = {A[14:0], A[15]};
  assign rotateRight = {A[0], A[15:1]};

  always @(*) begin
    case (op)
      4'b0000: Y = A + B;
      4'b0001: Y = A - B;
      4'b0010: Y = A & B;
      4'b0011: Y = A | B;
      4'b0100: Y = A ^ B;
      4'b0101: Y = notA;
      4'b0110: Y = shiftLeft;
      4'b0111: Y = shiftRight;
      4'b1000: Y = rotateLeft;
      4'b1001: Y = rotateRight;
      default: Y = 16'b0;
    endcase
  end

endmodule