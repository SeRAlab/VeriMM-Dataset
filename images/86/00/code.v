module top_module(
	CLK,
	RESET,
	D,
	Q,
	EN,
	LOAD,
	DOWN
);parameter WIDTH = 8;

	input CLK;
	input RESET;
	input [WIDTH - 1:0] D;	
	output reg [WIDTH - 1:0] Q;
	input EN;
	input LOAD;
	input DOWN;
	
	always @ (posedge CLK)
		if(RESET)
			Q <= 0;
		else if(EN)
		begin
			if(LOAD)
				Q <= D;
			else if(DOWN)
				Q <= Q - 1;
			else
				Q <= Q + 1;
		end
	
endmodule