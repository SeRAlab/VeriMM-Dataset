module top_module(
    input sys_rst,
    input rd_en,
    input rd_clk,
    output reg [8:0] dout,
    output reg empty,
    output reg gmii_tx_en,
    output reg [7:0] gmii_txd,
    output reg gmii_tx_clk
);parameter FIFO_DEPTH = 4096;
parameter FIFO_WIDTH = 9;

reg [FIFO_WIDTH-1:0] fifo [0:FIFO_DEPTH-1];
reg [11:0] wr_ptr = 0;
reg [11:0] rd_ptr = 0;
reg [11:0] next_wr_ptr = 0;
reg [11:0] next_rd_ptr = 0;
reg [11:0] fifo_count = 0;

always @(posedge rd_clk) begin
    if (rd_en && !empty) begin
        dout <= fifo[rd_ptr];
        rd_ptr <= rd_ptr + 1;
        fifo_count <= fifo_count - 1;
        if (fifo_count == 0) begin
            empty <= 1;
        end
    end
end

always @(posedge gmii_tx_clk) begin
    if (gmii_tx_en) begin
        gmii_txd <= fifo[rd_ptr];
        rd_ptr <= rd_ptr + 1;
        fifo_count <= fifo_count - 1;
        if (fifo_count == 0) begin
            empty <= 1;
        end
    end
end

always @(posedge rd_clk) begin
    if (next_rd_ptr != rd_ptr) begin
        empty <= 0;
    end
end

always @(posedge rd_clk) begin
    if (sys_rst) begin
        wr_ptr <= 0;
        rd_ptr <= 0;
        next_wr_ptr <= 0;
        next_rd_ptr <= 0;
        fifo_count <= 0;
        empty <= 1;
    end else begin
        wr_ptr <= next_wr_ptr;
        rd_ptr <= next_rd_ptr;
        fifo_count <= fifo_count + (next_wr_ptr != next_rd_ptr ? 1 : 0);
    end
end

always @(posedge rd_clk) begin
    if (!empty && rd_ptr == wr_ptr) begin
        wr_ptr <= wr_ptr + 1;
        fifo_count <= fifo_count - 1;
    end
end

always @(posedge rd_clk) begin
    if (fifo_count < FIFO_DEPTH) begin
        next_wr_ptr <= wr_ptr + 1;
    end else begin
        next_wr_ptr <= wr_ptr;
    end
end

assign gmii_tx_clk = rd_clk;

endmodule