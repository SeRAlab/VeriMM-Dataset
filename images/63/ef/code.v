module top_module(A, B, S0, Y);input A, B, S0;
  output Y;
  wire N1, N2, N3, N4, N5, N6;
  
  not (N1, B);
  and (N2, A, B);
  and (N3, S0, N1);
  and (N4, S0, A);
  not (N5, N1);
  or (N6, N2, N4);
  or (Y, N3, N5, N6);
endmodule