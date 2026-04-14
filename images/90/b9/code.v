module top_module(
	input clk, rst, wr_en,
	input[15:0] addr, data_in,
	output[15:0] data_out, test_data_out
);reg [15:0] data [0:63];
	
	assign data_out = data[addr[5:0]];
	assign test_data_out = data[0];
	
	always @(posedge clk)
	begin
		
		if(wr_en)
		begin
			data[addr[5:0]] = data_in;
		end
	end
	
endmodule