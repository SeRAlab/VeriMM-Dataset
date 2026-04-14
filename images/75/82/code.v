module top_module(reset,CLK,Q);input wire CLK,reset;
	output reg[3:0] Q;
	wire [3:0] D;

	assign D[0] = ~Q[0]; 
	assign D[1] = (Q[1] & ~Q[0])|(Q[0] & ~Q[1]); 
	assign D[2] = (~Q[2] & Q[1] & Q[0])|(Q[2] & ~Q[1])|(Q[2] & ~Q[0]); 
	assign D[3] = (~Q[3] & Q[2] & Q[0] & Q[1])|(~Q[2] & Q[3])|(~Q[0] & Q[3])|(~Q[1] & Q[3]); 
	always @ (posedge CLK)Q <= D; 

	endmodule