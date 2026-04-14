module top_module(
	input [2:0] Q, 
	output [2:0] d 
	
);assign d[0] = (~Q[2] & ~Q[1] & Q[0]) ;

assign d[1] = (~Q[2] & Q[1] & ~Q[0]);

assign d[2] = (~Q[2] & ~Q[1] & ~Q[0]); 

endmodule