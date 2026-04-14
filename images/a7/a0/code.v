module top_module(comp_out, pc_in, data_in, rs_in, rt_in, enable);parameter word_size = 32;
	
	input [word_size-1:0] data_in, rs_in, rt_in, pc_in;
	input enable;
	
	output reg [word_size-1:0] comp_out;

	always @ (enable or data_in or rs_in or rt_in or pc_in)
	if (enable) begin
	if (rs_in == rt_in) comp_out <= data_in[19:0];
	else comp_out <= pc_in;
	end
	
	
endmodule