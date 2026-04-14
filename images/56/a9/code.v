module top_module( A, B, Ci, S, Co );input A, B, Ci;
  output S, Co;
  wire   n1, n2, n3, n4, n5, n6, n7, n8, n9, n10;

  xor  U1 ( n1, A, B );       // Use XOR gate instead of XNOR
  xor  U2 ( S, n1, Ci );      // Use XOR gate for the sum
  and  U3 ( n2, A, B );       // Use AND gate instead of NAND
  and  U4 ( Co, n2, Ci );     // Use AND gate for carry out
  not  U5 ( n3, A );          // Use NOT gate
  not  U6 ( n4, B );          // Use NOT gate
  and  U7 ( n5, n3, n4 );     // Use AND gate instead of NAND
  and  U8 ( n6, n5, Ci );     // Use AND gate instead of NAND
  and  U9 ( n7, n3, B );      // Use AND gate instead of NAND
  and  U10 ( n8, A, n4 );     // Use AND gate instead of NAND
  and  U11 ( n9, n7, n8 );     // Use AND gate instead of NAND
  and  U12 ( n10, n9, Ci );   // Use AND gate instead of NAND
  or   U13 ( Co, n6, n10 );   // Use OR gate for final carry out
endmodule