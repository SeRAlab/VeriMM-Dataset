module top_module(
  input clk,
  input [7:0] fifo_wdata,
  input fifo_wr,
  output fifo_FF,
  output reg [7:0] r_dat,  // Changed to reg
  output wfifo_empty,
  output [5:0] wfifo_used
);reg [7:0] buffer [0:63];
  reg [5:0] wr_ptr;
  reg [5:0] rd_ptr;
  reg [5:0] used;
  
  assign fifo_FF = used == 64;
  assign wfifo_empty = used == 0;
  assign wfifo_used = used;
  
  always @(posedge clk) begin
    if (fifo_wr && !fifo_FF) begin
      buffer[wr_ptr] <= fifo_wdata;
      wr_ptr <= wr_ptr + 1;
      used <= used + 1;
    end
    if (!wfifo_empty) begin
      r_dat <= buffer[rd_ptr];
      rd_ptr <= rd_ptr + 1;
      used <= used - 1;
    end
  end
  
endmodule