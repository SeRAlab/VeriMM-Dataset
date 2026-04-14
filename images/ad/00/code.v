module top_module(A, X1, X0, X);input A;
  input X1;
  input X0;
  output X;
  
  assign X = A ? X1 : X0;
  
endmodule