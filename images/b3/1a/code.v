module top_module(clk, d_in, q_out);input clk; 
	input [9:0] d_in;
	output[9:0] q_out;
	reg[9:0] q_out;

	
	always @(posedge clk) begin
		q_out = d_in;
	end
endmodule