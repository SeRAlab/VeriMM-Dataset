module top_module(MDR_data, Mem_write_enable, BusData_out, Mdata_out);input Mem_write_enable;
	input[31:0] MDR_data;
	output[31:0] BusData_out, Mdata_out;
	assign Mdata_out = (Mem_write_enable) ? MDR_data : 0; 
	assign BusData_out = (!Mem_write_enable) ? MDR_data : 0; 
endmodule