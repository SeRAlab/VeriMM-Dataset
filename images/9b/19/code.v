module top_module(
	input 	a , 
	input 	b , 
	input 	c , 
	output 	y
);assign y = a?(b?(a & c ):c):(!c);
endmodule