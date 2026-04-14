module top_module(out,funct,InitialOut,dt,clk,reset);output [17:0] out; 				
	input signed [17:0] funct;      
	input [3:0] dt ;				
	input clk, reset;
	input signed [17:0] InitialOut; 
	
	wire signed	[17:0] out, v1new ;
	reg signed	[17:0] v1 ;
	
	always @ (posedge clk) 
	begin
		if (reset==0) 
			v1 <= InitialOut ; 
		else 
			v1 <= v1new ;	
	end
	assign v1new = v1 + (funct>>>dt) ;
	assign out = v1 ;endmodule