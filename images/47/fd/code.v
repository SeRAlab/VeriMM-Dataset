module top_module(
    // inputs:
    clk,
    fifo_rd,
    rst_n,

    // outputs:
    fifo_EF,
    fifo_rdata,
    rfifo_full,
    rfifo_used
);output fifo_EF;
    output [7:0] fifo_rdata;
    output rfifo_full;
    output [5:0] rfifo_used;
    input clk;
    input fifo_rd;
    input rst_n;

    reg [31:0] bytes_left;
    wire fifo_EF;
    reg fifo_rd_d;
    wire [7:0] fifo_rdata;
    wire new_rom;
    wire [31:0] num_bytes;
    wire [6:0] rfifo_entries;
    wire rfifo_full;
    wire [5:0] rfifo_used;

    // counter for bytes left in FIFO
    always @(posedge clk or negedge rst_n) begin
        if (rst_n == 0) begin
            bytes_left <= 32'h0;
        end else begin
            if (fifo_rd_d) begin
                // decrement on read
                bytes_left <= bytes_left - 1'b1;
            end

            // catch new contents
            if (new_rom) begin
                bytes_left <= num_bytes;
            end
        end
    end

    // calculate FIFO fullness and usage
    assign fifo_EF = bytes_left == 32'b0;
    assign rfifo_full = bytes_left > 7'h40;
    assign rfifo_entries = (rfifo_full) ? 7'h40 : bytes_left;
    assign rfifo_used = rfifo_entries[5:0];

    // read data from FIFO
    assign fifo_rdata = (bytes_left > 0 && !fifo_EF && fifo_rd_d) ? 8'b1 : 8'b0;

    // reset FIFO on reset signal
    always @(negedge rst_n) begin
        if (rst_n == 0) begin
            fifo_rd_d <= 1'b0;
            bytes_left <= 32'h0;
        end
    end

    // catch new contents
    always @(posedge clk) begin
        if (new_rom) begin
            bytes_left <= num_bytes;
        end
        fifo_rd_d <= fifo_rd;
    end

endmodule