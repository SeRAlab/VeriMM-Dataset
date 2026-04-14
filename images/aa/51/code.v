module FIFO (
	input clk,
	input rst_n,
	input write_en,
	input [7:0] write_data,
	input read_en,
	output reg [7:0] read_data,
	output full,
	output empty
);
    parameter WIDTH = 8;
    parameter DEPTH = 16;

    reg [WIDTH-1:0] fifo_buffer [DEPTH-1:0];
    reg [3:0] write_ptr = 0;
    reg [3:0] read_ptr = 0;
    reg [4:0] fifo_count = 0;

    assign full = (fifo_count == DEPTH);
    assign empty = (fifo_count == 0);

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            write_ptr <= 0;
            read_ptr <= 0;
            fifo_count <= 0;
        end else begin
            if (write_en && !full) begin
                fifo_buffer[write_ptr] <= write_data;
                write_ptr <= write_ptr + 1;
                fifo_count <= fifo_count + 1;
            end
            if (read_en && !empty) begin
                read_data <= fifo_buffer[read_ptr];
                read_ptr <= read_ptr + 1;
                fifo_count <= fifo_count - 1;
            end
        end
    end
endmodule