module top_module(
  input clk,
  input rst,
  input [127 : 0] din,
  input wr_en,
  input rd_en,
  output reg [127 : 0] dout,
  output reg full,
  output reg empty,
  output reg [6 : 0] data_count
);parameter DEPTH = 128; // Define a parameter for the depth of the FIFO
  reg [127 : 0] fifo_mem [0 : DEPTH-1]; // FIFO memory array
  integer head, tail, count;

  // Asynchronous reset
  always @(posedge clk or posedge rst) begin
    if (rst) begin
      head <= 0;
      tail <= 0;
      count <= 0;
      full <= 0;
      empty <= 1;
    end else begin
      // Write operation
      if (wr_en && !full) begin
        fifo_mem[tail] <= din;
        tail <= (tail + 1) % DEPTH;
        count <= count + 1;
      end
      // Read operation
      if (rd_en && !empty) begin
        dout <= fifo_mem[head];
        head <= (head + 1) % DEPTH;
        count <= count - 1;
      end
      
      // Update full and empty flags
      full <= (count == DEPTH);
      empty <= (count == 0);
    end
  end

  // Update data_count output
  always @(*) begin
    data_count = count;
  end

endmodule