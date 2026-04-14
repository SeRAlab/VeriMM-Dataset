module top_module(op,din0,din1,din2,dout) ;input   [1:0]  op ;
  input   [4:0]  din0 ;
  input   [4:0]  din1 ;
  input   [4:0]  din2 ;
  output  [4:0]  dout ;
  
  assign dout = op[1] ? din2 : 
                op[0] ? din1 :
                        din0 ;endmodule