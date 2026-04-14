module top_module(
    wr,
    rd,
    fifo_we,
    fifo_rd,
    wptr,
    rptr,
    fifo_full,
    fifo_empty,
    fifo_threshold,
    fifo_overflow,
    fifo_underflow,
    clk,
    rst_n
);parameter DEPTH = 32;

input wr;
input rd;
input fifo_we;
input fifo_rd;
input [4:0] wptr;
input [4:0] rptr;
output fifo_full;
output fifo_empty;
output fifo_threshold;
output fifo_overflow;
output fifo_underflow;
input clk;
input rst_n;

reg [4:0] fifo_count;
reg [5:0] fifo_depth = DEPTH - 1;
reg [5:0] fifo_threshold_value = DEPTH - 2;

wire fifo_full;
assign fifo_full = ((wptr == rptr) && fifo_we && (fifo_count == fifo_depth));

wire fifo_empty;
assign fifo_empty = ((wptr == rptr) && fifo_rd && (fifo_count == 0));

wire fifo_threshold;
assign fifo_threshold = ((fifo_count <= fifo_threshold_value) && (fifo_count > 0));

wire fifo_overflow;
assign fifo_overflow = (!fifo_rd && fifo_full);

wire fifo_underflow;
assign fifo_underflow = (!fifo_we && fifo_empty);

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        fifo_count <= 0;
    end
    else begin
        if (fifo_we && ~fifo_rd) begin
            fifo_count <= fifo_count + 1;
        end
        else if (~fifo_we && fifo_rd) begin
            fifo_count <= fifo_count - 1;
        end
    end
end

endmodule