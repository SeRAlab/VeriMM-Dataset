module top_module(
  clk, rd_en, rst, empty, wr_en, full, prog_empty, prog_full, dout, din
);input clk;
  input rd_en;
  input rst;
  output empty;
  input wr_en;
  output full;
  output prog_empty;
  output prog_full;
  output reg [35 : 0] dout;  // Changed to reg to fix invalid l-value issue
  input [35 : 0] din;

  reg [35:0] fifo_mem [0:511];
  reg [8:0] wr_ptr;
  reg [8:0] rd_ptr;
  wire [8:0] fifo_count;
  wire [8:0] fifo_depth = 512;
  wire [8:0] almost_full_threshold = 504;
  wire [8:0] almost_empty_threshold = 8;

  // empty flag
  assign empty = (fifo_count == 0);

  // full flag
  assign full = (fifo_count == fifo_depth);

  // programmable empty flag
  assign prog_empty = (fifo_count <= almost_empty_threshold);

  // programmable full flag
  assign prog_full = (fifo_count >= almost_full_threshold);

  // write operation
  always @(posedge clk) begin
    if (rst) begin
      wr_ptr <= 0;
    end else if (wr_en && !full) begin
      fifo_mem[wr_ptr] <= din;
      wr_ptr <= wr_ptr + 1;
    end
  end

  // read operation
  always @(posedge clk) begin
    if (rst) begin
      rd_ptr <= 0;
      dout <= 0; // Initialize dout on reset
    end else if (rd_en && !empty) begin
      dout <= fifo_mem[rd_ptr];
      rd_ptr <= rd_ptr + 1;
    end
  end

  // count operation
  assign fifo_count = (wr_ptr >= rd_ptr) ? (wr_ptr - rd_ptr) : (wr_ptr + fifo_depth - rd_ptr);

endmodule