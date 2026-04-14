module top_module(
	input clk, 
	input resetn, 
	output [3:0] rand_out);reg [3:0] temp;

	always @(posedge clk, negedge resetn)
	begin 
		if (~resetn) temp <= 4'd15; 
		else temp <= {(temp[3]^temp[1]), temp[1:0], temp[3]};	
	end

	assign rand_out = temp[3:0];endmodule