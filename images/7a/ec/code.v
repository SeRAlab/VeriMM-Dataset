module top_module( B_in, A_out );input [2:0] B_in;
  output [2:0] A_out;
  wire n1, n2, n3, n4, n5, n6;

  not U1 (n1, B_in[0]);
  not U2 (n2, B_in[1]);
  not U3 (n3, B_in[2]);
  and U4 (n4, n1, n2);
  and U5 (n5, B_in[0], n2);
  and U6 (n6, n1, B_in[1]);
  or U7 (A_out[0], n5, n6);
  or U8 (A_out[1], n4, n3);
  or U9 (A_out[2], B_in[2], n6);
endmodule