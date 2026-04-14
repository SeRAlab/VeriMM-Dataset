module top_module(
  input clk,
  input fifo_rd,
  input rst_n,
  output fifo_EF,
  output reg [7:0] fifo_rdata,
  output rfifo_full,
  output reg [5:0] rfifo_used
);// Constants
  parameter FIFO_DEPTH = 64;

  // Internal signals
  reg [7:0] fifo_data [0:FIFO_DEPTH-1];
  reg [5:0] fifo_head;
  reg [5:0] fifo_tail;
  reg [5:0] fifo_count;

  // Outputs
  assign fifo_EF = (fifo_count == 0);
  assign rfifo_full = (fifo_count == FIFO_DEPTH);
  assign rfifo_used = fifo_count;

  // Read data from FIFO
  always @(posedge clk) begin
    if (rst_n == 0) begin
      fifo_rdata <= 8'b0;
      fifo_head <= 6'b0;
      fifo_tail <= 6'b0;
      fifo_count <= 6'b0;
    end else if (fifo_rd && fifo_count > 0) begin
      fifo_rdata <= fifo_data[fifo_head];
      fifo_head <= fifo_head + 1;
      fifo_count <= fifo_count - 1;
    end
  end

  // Write data to FIFO
  always @(posedge clk) begin
    if (rst_n == 0) begin
      fifo_head <= 6'b0;
      fifo_tail <= 6'b0;
      fifo_count <= 6'b0;
    end else if (!fifo_rd && fifo_count < FIFO_DEPTH) begin
      fifo_data[fifo_tail] <= fifo_rdata;
      fifo_tail <= fifo_tail + 1;
      fifo_count <= fifo_count + 1;
    end
  end

endmodule