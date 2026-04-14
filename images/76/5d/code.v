module top_module(input [3:0] in, output [3:0] out);// Output for input less than 4
	assign out = (in < 4) ? (in * 2) :
	
	// Output for input between 4 and 7 (inclusive)
	               (in <= 7) ? (in * in) :
	               
	// Output for input greater than 7
	                   (in / 2);
	                   
endmodule