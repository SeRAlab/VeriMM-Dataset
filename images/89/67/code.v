module fsm_module8 (
	input clk,
	input g,
	output v);reg [2:0] state = 0;
	
	always @(posedge clk) begin
		state <= { ~(state[2] & g), (state[1] | g), (state[0] ^ g) };		
	end
	
	assign v = ~(state[2] | state[1] | state[0]);
	
endmodule