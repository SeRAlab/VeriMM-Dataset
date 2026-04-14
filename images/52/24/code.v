module top_module(empty,
    full,
    dout,
    clk,
    srst,
    din,
    rd_en,
    wr_en);output empty;
  output full;
  output [127:0]dout;
  input clk;
  input srst;
  input [127:0]din;
  input rd_en;
  input wr_en;

  reg [9:0] wr_ptr;
  reg [9:0] rd_ptr;
  reg [9:0] count;
  wire [9:0] next_wr_ptr;
  wire [9:0] next_rd_ptr;
  wire [9:0] next_count;
  reg [127:0] fifo [0:1023]; // Change to reg to fix the error

  assign empty = (count == 0);
  assign full = (count == 1024);
  assign dout = fifo[rd_ptr];

  always @(posedge clk) begin
    if (srst) begin
      wr_ptr <= 0;
      rd_ptr <= 0;
      count <= 0;
    end else begin
      wr_ptr <= next_wr_ptr;
      rd_ptr <= next_rd_ptr;
      count <= next_count;
    end
  end

  assign next_wr_ptr = (wr_en && !full) ? wr_ptr + 1 : wr_ptr;
  assign next_rd_ptr = (rd_en && !empty) ? rd_ptr + 1 : rd_ptr;
  assign next_count = count + (wr_en && !full) - (rd_en && !empty);

  always @(posedge clk) begin // Add an always block to handle write operations
    if (wr_en && !full) begin
      fifo[wr_ptr] <= din; // Use non-blocking assignment to write data
    end
  end

endmodule