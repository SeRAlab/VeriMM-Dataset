module top_module(n,i,c,e,Q, clk, rst);input wire n,i,c,e;	
	input wire clk,rst;	
	output wire [2:0]Q;	
	
	reg [2:0]state=1;	
	
	assign Q=state;	
	
	always @ (posedge clk or negedge rst)	
		if (~rst)begin 
			state = 1; end	
		else if (state == 1 && n)begin	
			state = 2; end	
		else if (state == 1 && ~n)begin 	
			state = 6; end	
		else if (state == 2 && i)begin	
			state = 3; end	
		else if (state == 2 && ~i)begin	
			state = 6; end	
		else if (state == 3 && c)begin	
			state = 4; end	
		else if (state == 3 && ~c)begin	
			state = 6; end	
		else if (state == 4 && e)begin	
			state = 7; end 
		else if (state == 4 && ~e)begin	
			state = 6; end	
endmodule