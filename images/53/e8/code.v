module top_module(q,d,clk,clear);output reg q;
	input wire d,clk,clear;
	
	always@(posedge clk or negedge clear) begin
		if(clear==1'b0) begin
			q<=1'b0;
		end else begin
			q<=d;
		end
	end 
endmodule