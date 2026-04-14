module top_module(segmentos, d1);output reg [6:0] segmentos;
	output  d1;
	parameter [3:0] A = 4'b0000;
	
	always @(A) begin
		if(A == 4'b0000) segmentos = ~(7'b1111110);
		else segmentos = ~(7'b0000001);
	end
	assign d1 = 0;
endmodule