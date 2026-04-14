module top_module(A, B, Y);input A, B;
  wire A, B;

  output [0:3] Y;
  wire [0:3] Y;

  
  
  
  
  

  assign Y[0] = ~((~A)&(~B));
  assign Y[1] = ~(( A)&(~B));
  assign Y[2] = ~((~A)&( B));
  assign Y[3] = ~(( A)&( B));

endmodule