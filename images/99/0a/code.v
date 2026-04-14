module top_module(
	input [255:0] dataa,
	input clk,
	input [1:0] in_select,
	output reg [511:0] result,
	input reset
	);always @ ( posedge clk ) begin
		if( reset ) result = 0;
		else
		if( in_select == 3 ) begin
			result[15:0]   <= dataa[15:0];
			result[31:16]   <= dataa[79:65];
			result[47:32]   <= dataa[143:128];
			result[63:48]   <= dataa[207:192];
			result[79:64]   <= dataa[31:16];
			result[95:80]   <= dataa[95:80];
			result[111:96]  <= dataa[159:144];
			result[127:112] <= dataa[223:208];
			result[143:128] <= dataa[47:32];
			result[159:144] <= dataa[111:96];
			result[175:160] <= dataa[175:160];
			result[191:176] <= dataa[239:224];
			result[207:192] <= dataa[63:48];
			result[223:208] <= dataa[127:112];
			result[239:224] <= dataa[191:176];
			result[255:240] <= dataa[255:240];
		end
	end 

endmodule