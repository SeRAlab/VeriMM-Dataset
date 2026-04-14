module top_module(A0, A1, A2, A3, S, Z);input A0, A1, A2, A3; // 4 input lines
  input [1:0] S; // 2-bit select lines
  output Z; // Output

  assign Z = (S == 2'b00) ? A0 :
             (S == 2'b01) ? A1 :
             (S == 2'b10) ? A2 :
             (S == 2'b11) ? A3 : 1'b0; // Default case
endmodule