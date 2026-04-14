module top_module( A, B, C, D, h0, h1, h2, h3, h4, h5, h6);input A, B, C, D; 
  output h0, h1, h2, h3, h4, h5, h6; 
  assign h0 = (~A&~B&~C&D) | (~A&B&~C&~D); 
  assign h1 = (~A&B&~C&D) | (~A&B&C&~D); 
  assign h2 = ~A&~B&C&~D; 
  assign h3 = (~A&B&~C&~D) | (~A&~B&~C&D) | (~A&B&C&D); 
  assign h4 = (~A&D) | (~A&B&~C) | (~B&~C&D); 
  assign h5 = (~A&~B&D) | (~A&C&D) | (~A&~B&C); 
  assign h6 = (~A&~B&~C) | (~A&B&C&D); 
 endmodule