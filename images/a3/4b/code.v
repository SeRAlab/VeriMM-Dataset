module top_module(
	input clk, 
	input resetn,
	input gameover,
	output [9:0] rand_out);reg [9:0] temp;

	always @(posedge clk, negedge resetn)
	begin 
		if (~resetn) temp <= 10'b11_1111_1111; 
		else if (~gameover) temp <= {(temp[8]^temp[6]^temp[3]^temp[1]), temp[7:0], temp[9]};
		else temp<= 10'b00_0000_0000; 
	end

	assign rand_out = temp[9:0];endmodule