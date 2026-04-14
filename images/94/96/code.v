module top_module(input [3:0] A, B, C, D, output EQ, GT);wire a_greater_b, c_greater_d;
  
  assign a_greater_b = (A > B);
  assign c_greater_d = (C > D);
  
  assign EQ = (A == B) && (B == C) && (C == D);
  
  assign GT = (a_greater_b || ((A == B) && c_greater_d));
  
endmodule