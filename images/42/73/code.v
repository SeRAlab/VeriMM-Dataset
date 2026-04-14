module top_module(empty,
    full,
    dout,
    clk,
    din,
    rst,
    rd_en,
    wr_en);output empty;
  output full;
  output reg [4:0] dout; // Change from wire to reg to allow assignment in always block
  input clk;
  input [4:0] din;
  input rst;
  input rd_en;
  input wr_en;

  wire clk;
  wire [4:0] din;
  wire empty;
  wire full;
  wire rd_en;
  wire rst;
  wire wr_en;

  reg [4:0] fifo_mem [0:1023];
  reg [9:0] wr_ptr;
  reg [9:0] rd_ptr;
  reg [9:0] count;

  always @(posedge clk) begin
    if (rst) begin
      wr_ptr <= 0;
      rd_ptr <= 0;
      count <= 0;
    end else begin
      if (wr_en && !full) begin
        fifo_mem[wr_ptr] <= din;
        wr_ptr <= wr_ptr + 1;
        count <= count + 1;
      end
      if (rd_en && !empty) begin
        dout <= fifo_mem[rd_ptr]; // This assignment is now valid
        rd_ptr <= rd_ptr + 1;
        count <= count - 1;
      end
    end
  end

  assign empty = (count == 0);
  assign full = (count == 1024);

endmodule