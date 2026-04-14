module top_module(A, B, OP, R, COUT);input [3:0] A, B;
  input [1:0] OP;
  output reg [3:0] R;
  output reg COUT;

  always @(*) begin
    case (OP)
      2'b00: begin // addition
        R = A + B;
        COUT = (A[3] & B[3]) | (A[3] & ~R[3]) | (B[3] & ~R[3]);
      end
      2'b01: begin // subtraction
        R = A - B;
        COUT = (A[3] & ~B[3]) | (~R[3] & B[3]);
      end
      2'b10: begin // bitwise AND
        R = A & B;
        COUT = 1'b0;
      end
      2'b11: begin // bitwise OR
        R = A | B;
        COUT = 1'b0;
      end
      default: begin // bitwise XOR
        R = A ^ B;
        COUT = 1'b0;
      end
    endcase
  end

endmodule