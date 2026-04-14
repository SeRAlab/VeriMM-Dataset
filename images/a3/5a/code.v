module top_module(wr_rst_busy,
    dout,
    empty,
    full,
    rd_en,
    wr_en,
    clk,
    din,
    rst);output wr_rst_busy;
  output [63:0]dout;
  output empty;
  output full;
  input rd_en;
  input wr_en;
  input clk;
  input [63:0]din;
  input rst;

  reg [5:0] wr_ptr = 0;
  reg [5:0] rd_ptr = 0;
  reg [11:0] count = 0;
  wire [5:0] next_wr_ptr = wr_ptr + 1;
  wire [5:0] next_rd_ptr = rd_ptr + 1;
  wire [11:0] next_count = count + 1;
  wire [11:0] next_count_rd = count - 1;
  reg [63:0] ram [0:11];
  reg wr_rst_busy;
  wire [63:0]dout = ram[rd_ptr];
  wire empty = (count == 0);
  wire full = (count == 12);
  
  always @(posedge clk) begin
    if (rst) begin
      wr_ptr <= 0;
      rd_ptr <= 0;
      count <= 0;
      wr_rst_busy <= 1;
    end else if (wr_en && !full) begin
      ram[wr_ptr] <= din;
      wr_ptr <= next_wr_ptr;
      count <= next_count;
      wr_rst_busy <= 1;
    end else if (rd_en && !empty) begin
      rd_ptr <= next_rd_ptr;
      count <= next_count_rd;
      wr_rst_busy <= 1;
    end else begin
      wr_rst_busy <= 0;
    end
  end
endmodule