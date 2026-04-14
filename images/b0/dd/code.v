module top_module(clk_in, clk_out);input clk_in;

	output reg clk_out;
	
	reg [23:0]count;
	
	always @(posedge clk_in) begin
		count <= count+1; 
		if(count >= 500000) begin
			count <= 0; 
		end	
		clk_out = (count > 24'd250000) ? 1'b1 : 1'b0;
	end

endmodule