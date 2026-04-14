module top_module(
    wr_clk,
    rd_clk,
    wr_req,
    rd_req,
    clr,
    data_in,
    data_out,
    empty,
    full
);parameter DATA_WIDTH = 16;
parameter FIFO_DEPTH = 64;

input wr_clk;
input rd_clk;
input wr_req;
input rd_req;
input clr;
input [DATA_WIDTH-1:0] data_in;
output reg [DATA_WIDTH-1:0] data_out; // Change to reg type
output empty;
output full;

reg [DATA_WIDTH-1:0] fifo_mem [0:FIFO_DEPTH-1];
reg [6:0] wr_ptr = 0; // Changed to 7 bits to accommodate FIFO_DEPTH
reg [6:0] rd_ptr = 0; // Changed to 7 bits to accommodate FIFO_DEPTH
wire [6:0] wr_ptr_next = wr_ptr + 1; // Changed to 7 bits
wire [6:0] rd_ptr_next = rd_ptr + 1; // Changed to 7 bits
wire wr_ptr_wrap = (wr_ptr_next == FIFO_DEPTH) ? 1 : 0;
wire rd_ptr_wrap = (rd_ptr_next == FIFO_DEPTH) ? 1 : 0;
wire empty = (wr_ptr == rd_ptr) ? 1 : 0;
wire full = ((wr_ptr_wrap == 0) && (wr_ptr_next == rd_ptr)) ? 1 : 0;

always @(posedge wr_clk) begin
    if (clr) begin
        wr_ptr <= 0;
        rd_ptr <= 0;
    end else if (wr_req && !full) begin
        fifo_mem[wr_ptr] <= data_in;
        wr_ptr <= wr_ptr_wrap ? 0 : wr_ptr_next;
    end
end

always @(posedge rd_clk) begin
    if (clr) begin
        wr_ptr <= 0;
        rd_ptr <= 0;
    end else if (rd_req && !empty) begin
        data_out <= fifo_mem[rd_ptr];
        rd_ptr <= rd_ptr_wrap ? 0 : rd_ptr_next;
    end
end

endmodule