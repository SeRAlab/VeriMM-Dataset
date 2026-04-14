module top_module(Ax, Ay, Az, Bx, By, Bz, Cx, Cy, Cz, ABn);input[16 - 1:0] Ax; 
  input[16 - 1:0] Ay; 
  input[16 - 1:0] Az; 
  input[16 - 1:0] Bx; 
  input[16 - 1:0] By; 
  input[16 - 1:0] Bz; 
  output[16 - 1:0] Cx; 
  wire[16 - 1:0] Cx; 
  output[16 - 1:0] Cy; 
  wire[16 - 1:0] Cy; 
  output[16 - 1:0] Cz; 
  wire[16 - 1:0] Cz; 
  input ABn; 
  assign Cx = (ABn == 1'b1) ? Ax : Bx ; 
  assign Cy = (ABn == 1'b1) ? Ay : By ; 
  assign Cz = (ABn == 1'b1) ? Az : Bz ; 
  endmodule