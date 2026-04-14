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
  output reg [7:0] r_dat;          // changed to reg
  output reg wfifo_empty;          // changed to reg
  output reg [5:0] wfifo_used;     // changed to reg
  input clk;
  input [7:0] fifo_wdata;
  input fifo_wr;

  reg [7:0] fifo [63:0];
  reg [5:0] wfifo_used_reg;
  reg fifo_FF;                      // changed to reg

  // Write to FIFO
  always @(posedge clk) begin
    if (fifo_wr && !fifo_FF) begin
      fifo[wfifo_used_reg] <= fifo_wdata;
      wfifo_used_reg <= wfifo_used_reg + 1;
    end
  end

  // Read from FIFO
  always @(*) begin
    if (wfifo_used_reg == 0) begin
      r_dat = 8'b0;
      wfifo_empty = 1'b1;
    end else begin
      r_dat = fifo[0]; // Read from FIFO
      wfifo_empty = 1'b0;
    end

    if (wfifo_used_reg == 64) begin
      fifo_FF = 1'b1;
    end else begin
      fifo_FF = 1'b0;
    end
  end

  // Update wfifo_used
  always @(*) begin
    wfifo_used = wfifo_used_reg;
  end

endmodule