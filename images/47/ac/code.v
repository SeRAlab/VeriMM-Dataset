module top_module(op,din0,din1,din2,din3,dout) ;input   [1:0]  op ;
  input   [31:0]  din0 ;
  input   [31:0]  din1 ;
  input   [31:0]  din2 ;
  input   [31:0]  din3 ;
  output  [31:0]  dout ;
  
  assign dout = ( op == 2'd3 ) ? din3 : 
				( op == 2'd2 ) ? din2 :
                ( op == 2'd1 ) ? din1 :
                ( op == 2'd0 ) ? din0 :
				32'b0 ;endmodule