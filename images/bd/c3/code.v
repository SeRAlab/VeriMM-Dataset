module fifo(
	input clk,
	input rst_n,
	input wr_en,
	input rd_en,
	input [7:0] data_in,
	output reg [7:0] data_out,
	output reg full,
	output reg empty
);
reg [7:0] fifo_mem [15:0];
reg [3:0] write_ptr;
reg [3:0] read_ptr;
reg [4:0] fifo_count;

always @(posedge clk or negedge rst_n) begin
	if (!rst_n) begin
		write_ptr <= 4'd0;
		read_ptr <= 4'd0;
		fifo_count <= 5'd0;
		full <= 1'b0;
		empty <= 1'b1;
	end else begin
		if (wr_en && !full) begin
			fifo_mem[write_ptr] <= data_in;
			write_ptr <= write_ptr + 4'd1;
			fifo_count <= fifo_count + 5'd1;
		end
		if (rd_en && !empty) begin
			data_out <= fifo_mem[read_ptr];
			read_ptr <= read_ptr + 4'd1;
			fifo_count <= fifo_count - 5'd1;
		end
		
		full <= (fifo_count == 5'd16);
		empty <= (fifo_count == 5'd0);
	end
end
endmodule