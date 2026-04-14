module top_module(Y,carryout,carryin,A,B);output [3:0]Y;
  output carryout;
  input carryin;
  input [3:0]A,B;
  
  wire z, cout;
  wire [3:0] s;
  
  assign {cout, s} = A + B;
  
  
  assign z = cout | s > 9;
  assign Y = s + {1'b0, z, z, 1'b0};
  assign carryout = cout | z;
  
endmodule