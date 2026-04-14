module top_module(
	input [127:0] state_data_in,
	output [127:0] state_data_out
    );assign state_data_out[7:0]     = state_data_in[7:0];
	assign state_data_out[39:32]   = state_data_in[39:32];
	assign state_data_out[71:64]   = state_data_in[71:64];
	assign state_data_out[103:96]  = state_data_in[103:96];

	
	assign state_data_out[15:8]    = state_data_in[47:40];
	assign state_data_out[47:40]   = state_data_in[79:72];
	assign state_data_out[79:72]   = state_data_in[111:104];
	assign state_data_out[111:104] = state_data_in[15:8];

	
	assign state_data_out[23:16]   = state_data_in[87:80];
	assign state_data_out[87:80]   = state_data_in[23:16];
	assign state_data_out[55:48]   = state_data_in[119:112];
	assign state_data_out[119:112] = state_data_in[55:48];

	
	assign state_data_out[31:24]   = state_data_in[127:120];
	assign state_data_out[127:120] = state_data_in[95:88];
	assign state_data_out[95:88]   = state_data_in[63:56];
	assign state_data_out[63:56]   = state_data_in[31:24];

endmodule