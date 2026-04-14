module top_module(
  input clk,
  input fifo_clear,
  input [7:0] fifo_wdata,
  input fifo_wr,
  input rd_wfifo,
  output fifo_FF,
  output [7:0] r_dat,
  output wfifo_empty,
  output [5:0] wfifo_used
);reg [7:0] mem [63:0];  // FIFO memory
  reg [5:0] used;         // number of words used
  reg [5:0] head;         // index of the head of the FIFO
  reg [5:0] tail;         // index of the tail of the FIFO
  wire full;              // FIFO full flag
  wire empty;             // FIFO empty flag

  // Read and write pointers
  reg [5:0] r_ptr;
  reg [5:0] w_ptr;

  // Read and write data
  reg [7:0] r_data;
  reg [7:0] w_data;

  // Full flag
  assign fifo_FF = full;

  // Empty flag
  assign wfifo_empty = empty;

  // Used words
  assign wfifo_used = used;

  // Write operation
  always @(posedge clk) begin
    if (fifo_clear) begin
      // Clear the FIFO
      used <= 0;
      head <= 0;
      tail <= 0;
    end else if (fifo_wr && !full) begin
      // Write data to the FIFO
      mem[w_ptr] <= fifo_wdata;
      w_ptr <= w_ptr + 1;
      used <= used + 1;
      if (w_ptr == 63) begin
        w_ptr <= 0;
      end
    end
  end

  // Read operation
  always @(posedge clk) begin
    if (fifo_clear) begin
      // Clear the FIFO
      used <= 0;
      head <= 0;
      tail <= 0;
    end else if (!fifo_wr && !empty) begin
      // Read data from the FIFO
      r_data <= mem[r_ptr];
      r_ptr <= r_ptr + 1;
      used <= used - 1;
      if (r_ptr == 63) begin
        r_ptr <= 0;
      end
    end
  end

  // Full flag
  assign full = (used == 64);

  // Empty flag
  assign empty = (used == 0);

  // Read data
  assign r_dat = r_data;

endmodule