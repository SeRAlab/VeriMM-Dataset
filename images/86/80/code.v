module top_module(
  input clk,
  input [7:0] fifo_wdata,
  input fifo_wr,
  output reg fifo_FF,            // Changed output to reg
  output reg [7:0] r_dat,
  output reg wfifo_empty,        // Changed output to reg
  output reg [5:0] wfifo_used
);reg [7:0] fifo_mem [0:255];
  reg [7:0] read_ptr = 0;
  reg [7:0] write_ptr = 0;
  reg [7:0] next_write_ptr = 0;
  reg [7:0] next_read_ptr = 0;
  reg fifo_full = 0;
  reg fifo_empty = 1;

  always @(posedge clk) begin
    if (fifo_wr && !fifo_full) begin
      fifo_mem[write_ptr] <= fifo_wdata;
      next_write_ptr <= write_ptr + 1;
      if (next_write_ptr == 256) begin
        next_write_ptr <= 0;
      end
    end
    write_ptr <= next_write_ptr;

    if (!fifo_empty) begin
      r_dat <= fifo_mem[read_ptr];
      next_read_ptr <= read_ptr + 1;
      if (next_read_ptr == 256) begin
        next_read_ptr <= 0;
      end
    end
    read_ptr <= next_read_ptr;

    fifo_full <= (write_ptr == read_ptr) && !fifo_empty;
    fifo_empty <= (write_ptr == read_ptr) && !fifo_wr;

    wfifo_used <= write_ptr - read_ptr;
    fifo_FF <= fifo_full;
    wfifo_empty <= fifo_empty;
  end
endmodule