module top_module(op,din0,din1,dout) ;input           op ;
  input   [4:0]  din0 ;
  input   [4:0]  din1 ;
  output  [4:0]  dout ;
  
  assign dout = op ? din1 : din0 ;endmodule