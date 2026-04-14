module top_module(
	input iA,
	input iB,
	input iC,
	input iD,
	output oSegA,
	output oSegB
	
);assign oSegA =  rOperacion & (iA | ~iB | iC | iD ) & (iA | ~iB | ~iC | iD);
	assign oSegB = rOperacion;
	
 
 reg  rOperacion;
 
 
 always @ * 
 begin 
 
	 rOperacion = (iA | iB |iC | ~iD);
	
 end
 
 
 endmodule