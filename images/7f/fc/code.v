module top_module(
    input clk,
    input fifo_rd,
    input rst_n,
    output fifo_EF,
    output [7:0] fifo_rdata,
    output rfifo_full,
    output [5:0] rfifo_used
);reg [31:0] bytes_left;
    reg fifo_rd_d;
    wire new_rom;
    wire [31:0] num_bytes;
    wire [6:0] rfifo_entries;

    // Generate rfifo_entries
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            bytes_left <= 32'h0;
            fifo_rd_d <= 1'b0;
        end else begin
            fifo_rd_d <= fifo_rd;
            // decrement on read
            if (fifo_rd_d) begin
                bytes_left <= bytes_left - 1'b1;
            end
            // catch new contents
            if (new_rom) begin
                bytes_left <= num_bytes;
            end
        end
    end

    // Calculate FIFO buffer status
    assign fifo_EF = (bytes_left == 32'h0);
    assign rfifo_full = (bytes_left > 7'h40);
    assign rfifo_entries = (rfifo_full) ? 7'h40 : bytes_left;
    assign rfifo_used = rfifo_entries[5:0];

    // Set unused outputs to default values
    assign new_rom = 1'b0;
    assign num_bytes = 32'b0;
    assign fifo_rdata = 8'b0;

endmodule