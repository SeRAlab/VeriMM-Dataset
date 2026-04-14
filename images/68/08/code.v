module top_module(I, A, B, C, D, E, O);input [3:0] I;
  input [11:0] A, B, C, D, E;
  output reg [11:0] O;
  
  always @(*) begin
    case (I)
      4'b0000: O = A;
      4'b0001: O = B;
      4'b0010: O = C;
      4'b0011: O = D;
      4'b0100: O = E;
      default: O = 12'b0;
    endcase
  end
endmodule