module fsm_module1 (
	input clk,
	input h,
	output q);reg [2:0] state = 0;

	always @(posedge clk) begin
		state <= { state[2] ~^ h, ~state[1] & h, state[0] | h };		
	end
	
	assign q = |state;
	
endmodule