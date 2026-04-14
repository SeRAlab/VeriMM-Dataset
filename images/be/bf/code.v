module top_module(
  input [3:0] A, B,
  input CIN, BINV,
  input [1:0] OP,
  output reg COUT,
  output reg [3:0] Y
);reg [3:0] B_inv;
  assign B_inv = BINV ? ~B : B;
  
  always @(*) begin
    case(OP)
      2'b00: begin // Addition
        Y = A + B_inv + CIN;
        COUT = Y[4];
      end
      2'b01: begin // Subtraction
        Y = A - B_inv - ~CIN;
        COUT = ~Y[4];
      end
      2'b10: begin // Logical AND
        Y = A & B_inv;
        COUT = 1'b0;
      end
      2'b11: begin // Logical OR
        Y = A | B_inv;
        COUT = 1'b0;
      end
    endcase
  end
endmodule