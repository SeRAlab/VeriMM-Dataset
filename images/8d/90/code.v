module top_module( A, B, C, D, E, z0, z1, z2, z3, z4);input A, B, C, D, E; 
  output z0, z1, z2, z3, z4; 
  assign z0 = (~A&E) | (~B&~C&~D&E); 
  assign z1 = (~A&~B&D) | (~A&B&C&~D) | (A&~B&~C&~D); 
  assign z2 = (~A&~B&C) | (~A&C&D) | (A&~B&~C&~D); 
  assign z3 = (~A&B&~C&~D) | (A&~B&~C&D&~E); 
  assign z4 = (~A&B&D) | (~A&B&C) | (A&~B&~C&~D) | (A&~B&~C&~E); 
 endmodule