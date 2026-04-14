module top_module(
  // inputs:
  clk,
  fifo_wdata,
  fifo_wr,

  // outputs:
  fifo_FF,
  r_dat,
  wfifo_empty,
  wfifo_used
);output fifo_FF;
  output [7:0] r_dat;
  output wfifo_empty;
  output [5:0] wfifo_used;
  input clk;
  input [7:0] fifo_wdata;
  input fifo_wr;

  wire fifo_FF;
  wire [7:0] r_dat;
  wire wfifo_empty;
  wire [5:0] wfifo_used;

  // Simulation-only contents
  always @(posedge clk) begin
    if (fifo_wr) $write("%c", fifo_wdata);
  end

  assign wfifo_used = {6{1'b0}};
  assign r_dat = {8{1'b0}};
  assign fifo_FF = 1'b0;
  assign wfifo_empty = 1'b1;

endmodule