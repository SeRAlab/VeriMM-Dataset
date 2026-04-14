module top_module(Y, A, B, C, D);output wire Y;
  input wire A, B, C, D;
  
  assign Y  = (~(A|D))&(B&C&(~D));
endmodule