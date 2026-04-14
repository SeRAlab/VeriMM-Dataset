module fifo (
	input clk,
	input reset,
	input write_enable,
	input read_enable,
	input [7:0] data_in,
	output reg [7:0] data_out);reg [7:0] buffer [0:3];
integer write_ptr, read_ptr;
always @(posedge clk or posedge reset) begin
		if (reset) begin
			write_ptr <= 0;
			read_ptr <= 0;
		end else begin
			if (write_enable)
				buffer[write_ptr] <= data_in;
				write_ptr <= (write_ptr + 1) % 4;
			if (read_enable) begin
				data_out <= buffer[read_ptr];
				read_ptr <= (read_ptr + 1) % 4;
			end
		end
	end
	
endmodule