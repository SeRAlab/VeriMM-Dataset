module top_module(z, HEX);input z;
  output [6:0] HEX;
  
  assign HEX[0] = z;
  assign HEX[2:1] = 2'b00;
  assign HEX[5:3] = {3{z}};
  assign HEX[6] = 1;endmodule