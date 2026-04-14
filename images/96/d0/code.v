module top_module(Bus_data, Mdata_in, Mem_read_enable, MDMux_out);input Mem_read_enable;
	input[31:0] Bus_data, Mdata_in;
	output[31:0] MDMux_out;
	
	assign MDMux_out = (Mem_read_enable) ? Mdata_in : Bus_data;	
endmodule