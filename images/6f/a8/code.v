module top_module(In0,In1,dout);input [0:0]In0; 
  input [0:0]In1; 
  output [1:0]dout; 
  wire [0:0]In0; 
  wire [0:0]In1; 
  assign dout[1] = In1; 
  assign dout[0] = In0; 
 endmodule