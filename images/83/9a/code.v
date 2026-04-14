module top_module(
    // inputs:
    clk,
    fifo_clear,
    fifo_rd,
    rst_n,
    t_dat,
    wr_rfifo,

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
    input fifo_clear;
    input fifo_rd;
    input rst_n;
    input [7:0] t_dat;
    input wr_rfifo;

    reg [7:0] fifo_mem [63:0];
    reg [5:0] fifo_used;
    reg [5:0] fifo_head;
    reg [5:0] fifo_tail;
    wire fifo_empty = (fifo_used == 0);
    wire fifo_full = (fifo_used == 64);

    assign fifo_EF = fifo_empty || fifo_full;
    assign fifo_rdata = fifo_mem[fifo_tail];
    assign rfifo_full = fifo_full;
    assign rfifo_used = fifo_used;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            fifo_head <= 6'd0;
            fifo_tail <= 6'd0;
            fifo_used <= 6'd0;
        end else begin
            if (fifo_clear) begin
                fifo_head <= 6'd0;
                fifo_tail <= 6'd0;
                fifo_used <= 6'd0;
            end else begin
                if (wr_rfifo && !fifo_full) begin
                    fifo_mem[fifo_head] <= t_dat;
                    fifo_head <= fifo_head + 1;
                    fifo_used <= fifo_used + 1;
                end
                if (fifo_rd && !fifo_empty) begin
                    fifo_tail <= fifo_tail + 1;
                    fifo_used <= fifo_used - 1;
                end
            end
        end
    end

endmodule