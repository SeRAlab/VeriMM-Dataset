module fsm_module (
	input clk,
	input y,
	output w);reg [2:0] state = 0;
	
	always @(posedge clk) begin
		state <= { state[2] ^ y, ~state[1] & y, ~state[0] | y };		
	end
	
	assign w = ~|state;
	
endmodule