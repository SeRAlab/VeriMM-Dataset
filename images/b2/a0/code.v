module top_module(op,din0,din1,dout) ;input           op ;
  input   [31:0]  din0 ;
  input   [31:0]  din1 ;
  output  [31:0]  dout ;
  
  assign dout = ( op == 0 ) ? din0 : din1 ;endmodule