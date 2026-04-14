module top_module(x, y);input [31:0] x; 
  output [31:0] y; 
  assign y[31:29] = x[6:4] ^ x[17:15]; 
  assign y[28:0] = {x[3:0], x[31:7]} ^ {x[14:0],x[31:18]} ^ x[31:3]; 
 endmodule