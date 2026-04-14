module MUX4(A, B, C, D, S1, S0, Y);
  input [1:0] A, B, C, D;
  input [1:0] S1, S0;
  output reg [1:0] Y;

  always @(*) begin
    case ({S1, S0})
      2'b00: Y = A;
      2'b01: Y = B;
      2'b10: Y = C;
      2'b11: Y = D;
    endcase
  end
endmodule