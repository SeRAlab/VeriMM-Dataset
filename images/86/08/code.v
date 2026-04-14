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
    output reg [7:0] fifo_rdata; // Changed to reg
    output rfifo_full;
    output reg [5:0] rfifo_used; // Changed to reg
    input clk;
    input fifo_rd;
    input rst_n;

    reg [63:0] fifo;
    wire fifo_EF;
    wire rfifo_full;

    assign fifo_EF = (rfifo_used == 0);
    assign rfifo_full = (rfifo_used == 64);

    always @(posedge clk) begin
        if (rst_n == 0) begin
            fifo <= 64'h0;
            rfifo_used <= 6'h0;
            fifo_rdata <= 8'h0; // Initialize fifo_rdata on reset
        end else if (fifo_rd) begin
            fifo_rdata <= fifo[7:0];
            rfifo_used <= rfifo_used - 1;
            fifo <= {fifo[55:0], 8'h00};
        end else begin
            if (rfifo_used < 64) begin
                fifo <= {fifo[55:0], 8'h00};
                rfifo_used <= rfifo_used + 1;
            end
        end
    end

endmodule