module top_module(clk, out, in, write, reset);output reg out;
	input      in;
	input      clk, write, reset;
	
	always@(posedge clk) begin
		if(reset==0) begin
			out = 1'b0;
		end
		else if(write == 1'b0) begin
			out = in;
		end
	end
	
endmodule