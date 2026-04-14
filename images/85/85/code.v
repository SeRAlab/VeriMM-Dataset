module top_module(
	output C3,       
	output[2:0] S,   
	input[2:0] A, B, 
	input C0         
	);assign {C3, S} = A+B+C0;endmodule