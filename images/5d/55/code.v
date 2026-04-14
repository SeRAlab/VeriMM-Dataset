module top_module(
  clk,
  rst,
  din,
  wr_en,
  rd_en,
  dout,
  full,
  empty
);input clk;
input rst;
input [7 : 0] din;
input wr_en;
input rd_en;
output reg [7 : 0] dout;
output full;
output empty;

parameter DEPTH = 16; // FIFO depth
reg [7:0] fifo_mem[0:DEPTH-1]; // Memory array for FIFO
reg [3:0] wr_ptr = 0; // Write pointer
reg [3:0] rd_ptr = 0; // Read pointer
reg fifo_full = 0; // Full flag
reg fifo_empty = 1; // Empty flag

assign full = fifo_full;
assign empty = fifo_empty;

// Write data to FIFO
always @(posedge clk or posedge rst) begin
    if (rst) begin
        wr_ptr <= 0;
        rd_ptr <= 0;
        fifo_full <= 0;
        fifo_empty <= 1;
    end else begin
        if (wr_en && !fifo_full) begin
            fifo_mem[wr_ptr] <= din;
            wr_ptr <= wr_ptr + 1;
            fifo_empty <= 0; // Not empty after write
            if (wr_ptr + 1 == rd_ptr) begin // Check for full
                fifo_full <= 1;
            end
        end
        if (rd_en && !fifo_empty) begin
            dout <= fifo_mem[rd_ptr];
            rd_ptr <= rd_ptr + 1;
            fifo_full <= 0; // Not full after read
            if (wr_ptr == rd_ptr + 1) begin // Check for empty
                fifo_empty <= 1;
            end
        end
    end
end

endmodule