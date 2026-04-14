module top_module(
  input [3:0] A, B, C, D,
  input S0, S1,
  output reg Y
);always @ (S0 or S1 or A or B or C or D) begin
  case ({S1,S0})
    2'b00: Y = A;
    2'b01: Y = B;
    2'b10: Y = C;
    2'b11: Y = D;
  endcase
end

endmodule