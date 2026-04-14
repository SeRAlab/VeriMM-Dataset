module top_module(op,din0,din1,din2,din3,din4,din5,dout) ;input   [2:0]  op ;
	input   [31:0]  din0 ;
	input   [31:0]  din1 ;
	input   [31:0]  din2 ;
	input   [31:0]  din3 ;
	input   [31:0]  din4 ;
	input   [31:0]  din5 ;
	output  [31:0]  dout ;
  
	assign dout = 	( op == 3'h0 ) ? din0 : 
					( op == 3'h1 ) ? din1 : 
					( op == 3'h2 ) ? din2 : 
					( op == 3'h3 ) ? din3 : 
					( op == 3'h4 ) ? din4 : 
					( op == 3'h5 ) ? din5 : 
					0 ;endmodule