module top_module(
    input clk,
    input rst,
    input dataReady,
    input [7:0] data,
    input txBusy,
    output reg txStart,
    output reg [7:0] txData,
    output reg empty,
    output reg full
);parameter BUFFER_DEPTH = 64;
    parameter BUFFER_DEPTH_LOG2 = 6;

    reg [BUFFER_DEPTH_LOG2 - 1:0] wr_ptr;
    reg [BUFFER_DEPTH_LOG2 - 1:0] rd_ptr;
    reg [BUFFER_DEPTH_LOG2 - 1:0] fifo_count;
    reg [7:0] buffer [0:BUFFER_DEPTH-1];

    assign empty = (fifo_count == 0);
    assign full = (fifo_count == BUFFER_DEPTH);

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            txStart <= 0;
            txData <= 0;
            wr_ptr <= 0;
            rd_ptr <= 0;
            fifo_count <= 0;
        end else begin
            if (dataReady && !full) begin
                buffer[wr_ptr] <= data;
                wr_ptr <= wr_ptr + 1;
                fifo_count <= fifo_count + 1;
            end
            if (!txBusy && !empty) begin
                txStart <= 1;
                txData <= buffer[rd_ptr];
                rd_ptr <= rd_ptr + 1;
                fifo_count <= fifo_count - 1;
            end
        end
    end

endmodule