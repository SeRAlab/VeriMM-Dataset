module top_module(
	input			[7:0]q_in, 
	output wire	[7:0]q_out);assign q_out = {q_in[6], q_in[2], q_in[5], q_in[7], q_in[4], q_in[0], q_in[3], q_in[1]};
	
	
endmodule