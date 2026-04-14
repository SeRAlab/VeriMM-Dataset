module top_module(I,Clock,Q,Enable);input [3:0]I;
	input Clock,Enable;
	output reg[3:0] Q;
	
	always @(posedge Clock) begin
		if(Enable)begin
		Q <= I;
		end
	end
	
endmodule