module top_module(load, clk, k);input load, clk;
	reg[2:0] counter = 4'b0;
	
	
	output reg k = 0;
	
	
	
	
	always@(posedge clk) begin
		if (load) begin
			counter <= 4'b0; 
			k <= 0;
		end
		else begin
			counter <= counter + 3'b1;
		end
		if (counter == 3'd4) k <= 1;
	end
	
endmodule