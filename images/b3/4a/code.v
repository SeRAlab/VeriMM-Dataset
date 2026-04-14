module top_module(clk, O);input clk;
	output reg [1:0] O = 0;
	
	always@(posedge clk) begin
		O=O+1;
	end
	
endmodule