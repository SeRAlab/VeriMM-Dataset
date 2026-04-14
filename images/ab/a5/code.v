module top_module(z0, z1, z2, z3);output [31:0] z0, z1, z2, z3; 
  assign z0 = 1'bx >= (-1 * -1.17); 
  assign z1 = 1 ? 1 ? -1 : 'd0 : 0.0; 
  assign z2 = 1 ? -1 : 1 ? 'd0 : 0.0; 
  assign z3 = 1 ? -1 : 'd0; 
 endmodule