module top_module(G, H, S, R, color_index, clk);input G, H, S, R, clk;
	
	reg [7:0] index;
	
	output [7:0] color_index;
	
	always@(posedge clk)
	begin
		if(S)
			index <= 8'hf;
		else if (G)
			index <= 8'hf;
		else if (H)
			index <= 8'hf;
		else if (R)
			index <= 8'hf;
		else 
			index <= 8'hf;
	end
	
	assign color_index = index;

endmodule