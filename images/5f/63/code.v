module top_module(x, s2, cout);input [35:0] x;
  output s2;
  output [17:0] cout;

  wire [17:0]sum_1;
  assign {s2, sum_1} = x[17:0] + x[35:18]; 
  assign cout = sum_1;endmodule