module top_module(In0,In1,dout);input [7:0]In0; 
  input [1:0]In1; 
  output [9:0]dout; 
  wire [7:0]In0; 
  wire [1:0]In1; 
  assign dout[9:8] = In1; 
  assign dout[7:0] = In0; 
 endmodule