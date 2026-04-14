module top_module(
	A,		
	B,		
	C,		
	D,		
	Ctrl,	
	S		
	);parameter N = 16;
	input wire [N - 1: 0] A, B, C, D;
	output wire [N - 1: 0] S;
	input wire [1:0] Ctrl;
	
	assign S = (Ctrl == 2'b00) ? A :
				  ((Ctrl == 2'b01) ? B :
				  ((Ctrl == 2'b10) ? C : D
				  ));

endmodule