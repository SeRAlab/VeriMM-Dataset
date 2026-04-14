module top_module(wr_rst_busy,
    dout,
    empty,
    full,
    rd_en,
    wr_en,
    clk,
    din,
    rst);output reg wr_rst_busy;  // Change to reg type
  output reg [63:0] dout;  // Change to reg type
  output empty;
  output full;
  input rd_en;
  input wr_en;
  input clk;
  input [63:0] din;
  input rst;

  reg [63:0] fifo_mem [15:0];
  reg [3:0] wr_ptr = 0;
  reg [3:0] rd_ptr = 0;
  reg [3:0] count = 0;

  always @(posedge clk) begin
    if (rst) begin
      wr_ptr <= 0;
      rd_ptr <= 0;
      count <= 0;
      wr_rst_busy <= 1;
    end else begin
      wr_rst_busy <= wr_en;
      if (wr_en && !full) begin
        fifo_mem[wr_ptr] <= din;
        wr_ptr <= wr_ptr + 1;
        count <= count + 1;
      end
      if (rd_en && !empty) begin
        dout <= fifo_mem[rd_ptr];
        rd_ptr <= rd_ptr + 1;
        count <= count - 1;
      end
    end
  end

  assign empty = (count == 0);
  assign full = (count == 16);

endmodule