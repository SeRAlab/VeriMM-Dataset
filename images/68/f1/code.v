module top_module(
  input clk,
  input [63:0] din,
  input rst,
  input wr_en,
  input rd_en,
  output reg [63:0] dout, // Changed to reg type
  output empty,
  output valid,
  output full
);// FIFO parameters
  parameter WIDTH = 64;
  parameter DEPTH = 16;

  // FIFO memory
  reg [WIDTH-1:0] mem [0:DEPTH-1];
  integer head = 0;
  integer tail = 0;
  integer count = 0;

  // Empty and full flags
  assign empty = (count == 0);
  assign full = (count == DEPTH);

  // Write logic
  always @(posedge clk) begin
    if (rst) begin
      head <= 0;
      tail <= 0;
      count <= 0;
    end else if (wr_en && !full) begin
      mem[head] <= din;
      head <= (head == DEPTH-1) ? 0 : head + 1;
      count <= count + 1;
    end
  end

  // Read logic
  always @(posedge clk) begin
    if (rst) begin
      head <= 0;
      tail <= 0;
      count <= 0;
      dout <= 0; // Reset dout on reset
    end else if (rd_en && !empty) begin
      dout <= mem[tail];
      tail <= (tail == DEPTH-1) ? 0 : tail + 1;
      count <= count - 1;
    end
  end

  // Valid flag
  assign valid = (!empty && rd_en);

endmodule