module fifo(
	input clk,
	input reset,
	input write_enable,
	input read_enable,
	input [7:0] write_data,
	output reg [7:0] read_data,
	output empty);
reg [7:0] fifo_mem [0:15];
reg [3:0] write_ptr, read_ptr;
reg fifo_empty;

always @(posedge clk or posedge reset) begin
	if (reset) begin
		write_ptr <= 0;
		read_ptr <= 0;
		fifo_empty <= 1;
	end else begin
		if (write_enable && !fifo_empty) begin
			fifo_mem[write_ptr] <= write_data;
			write_ptr <= write_ptr + 1;
		end
		if (read_enable && !fifo_empty) begin
			read_data <= fifo_mem[read_ptr];
			read_ptr <= read_ptr + 1;
			if (read_ptr == write_ptr - 1)
				fifo_empty <= 1;
		end
	end
end

assign empty = fifo_empty;

endmodule