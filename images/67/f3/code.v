module top_module(a,b,sum,cout);input a,b;
  output sum,cout;
  
  assign #5 sum = a^b;
  assign #5 cout = a & b;
endmodule