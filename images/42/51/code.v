module top_module(
	input rst,
	input clk_i,
	input [15:0] div,
	output clk_o
	);reg r_clk_o = 1'b0;
	reg [15:0] count = 16'h0;
	
	always @(posedge clk_i) begin
		
		if(rst) begin
			r_clk_o = 1'b0;
			count = 16'h0;			
		end
		else begin
			count = count + 1;
			if(count == div) begin
				count = 16'h0;
				r_clk_o = ~r_clk_o;
			end
		end
	end
	
	assign clk_o = r_clk_o;
	
endmodule