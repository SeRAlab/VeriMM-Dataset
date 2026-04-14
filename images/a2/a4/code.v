module top_module(clk_in, clk_out);input clk_in;
	output reg clk_out;
	reg [2:0] contador;
	
	integer set = 1;
	
	always @(posedge clk_in)
	begin
		if (set == 1)
		begin
			clk_out = 0;
			contador = 3'b0;
			set = 0;
		end
		
		contador = contador+1;
		
		if (contador == 3'd4)
		begin
			clk_out = ~clk_out;
			contador = 3'd0;
		end
		
	end

endmodule