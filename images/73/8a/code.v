module top_module(A, B, C, D, S0, S1, Y);input A, B, C, D;
input S0, S1;
output Y;

reg Y;

always @ (S1 or S0 or A or B or C or D) begin
   case ({S1, S0})
      2'b00: Y = A;
      2'b01: Y = B;
      2'b10: Y = C;
      2'b11: Y = D;
   endcase
end

endmodule