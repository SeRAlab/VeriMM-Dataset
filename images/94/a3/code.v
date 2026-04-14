module top_module(
    rst,
    wr_clk,
    rd_clk,
    din,
    wr_en,
    rd_en,
    dout,
    full,
    almost_full,
    empty,
    almost_empty,
    prog_full,
    prog_empty
);input rst;
input wr_clk;
input rd_clk;
input [63:0] din;
input wr_en;
input rd_en;
output reg [63:0] dout; // changed from wire to reg
output full;
output almost_full;
output empty;
output almost_empty;
output prog_full;
output prog_empty;

parameter FIFO_DEPTH = 512;
parameter FIFO_ADDR_WIDTH = $clog2(FIFO_DEPTH);
parameter FIFO_DATA_WIDTH = 64;

reg [FIFO_ADDR_WIDTH-1:0] wr_ptr;
reg [FIFO_ADDR_WIDTH-1:0] rd_ptr;
reg [FIFO_ADDR_WIDTH-1:0] next_wr_ptr;
reg [FIFO_ADDR_WIDTH-1:0] next_rd_ptr;

reg [FIFO_DATA_WIDTH-1:0] fifo_mem [0:FIFO_DEPTH-1];

assign full = (wr_ptr == rd_ptr) && wr_en && !rd_en;
assign empty = (wr_ptr == rd_ptr) && !wr_en && rd_en;
assign almost_full = (wr_ptr == rd_ptr) && wr_en && rd_en;
assign almost_empty = (wr_ptr == rd_ptr) && wr_en && rd_en;

always @(posedge wr_clk) begin
    if (rst) begin
        wr_ptr <= 0;
        next_wr_ptr <= 0; // Initialize next_wr_ptr on reset
    end else if (wr_en && !full) begin
        fifo_mem[wr_ptr] <= din;
        wr_ptr <= next_wr_ptr; // Move the wr_ptr update here
        next_wr_ptr <= wr_ptr + 1;
    end
end

always @(posedge rd_clk) begin
    if (rst) begin
        rd_ptr <= 0;
        next_rd_ptr <= 0; // Initialize next_rd_ptr on reset
    end else if (rd_en && !empty) begin
        dout <= fifo_mem[rd_ptr];
        rd_ptr <= next_rd_ptr; // Move the rd_ptr update here
        next_rd_ptr <= rd_ptr + 1;
    end
end

// Removed the combined always block
// The wr_ptr and rd_ptr updates are handled inside the respective always blocks.

assign prog_full = (wr_ptr == rd_ptr) && wr_en && rd_en;
assign prog_empty = (wr_ptr == rd_ptr) && !wr_en && !rd_en;

endmodule