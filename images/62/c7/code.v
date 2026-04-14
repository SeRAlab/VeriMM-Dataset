module top_module(a,b,c,cout,sum);input a,b,c;
  output cout,sum;

  wire e1,e2,e3;

  assign e1 = a^b;
  assign e2 = a&b;
  assign sum = e1^c;
  assign e3 = e1&c;
  assign cout = e3|e2;
  
endmodule