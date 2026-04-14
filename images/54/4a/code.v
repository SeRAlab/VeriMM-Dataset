module top_module(
  input wr_clk,
  input rd_clk,
  input rst,
  input wr_en,
  input rd_en,
  input [DATA_WIDTH-1:0] wr_data,
  output reg full,
  output reg empty,
  output reg [DATA_WIDTH-1:0] rd_data // Changed to reg
);parameter DEPTH = 16; // depth of FIFO
parameter DATA_WIDTH = 8; // width of data to be stored in FIFO

reg [DATA_WIDTH-1:0] buffer [0:DEPTH-1]; // buffer to store data
reg [4:0] wr_ptr = 0; // write pointer
reg [4:0] rd_ptr = 0; // read pointer
reg [4:0] count = 0; // count of entries in buffer

always @(posedge wr_clk) begin
  if (rst) begin // reset
    wr_ptr <= 0;
    count <= 0;
    full <= 0;
    empty <= 1;
  end else if (wr_en && !full) begin // write
    buffer[wr_ptr] <= wr_data;
    wr_ptr <= wr_ptr + 1;
    count <= count + 1;
    if (count == DEPTH - 1) begin // Change comparison for full condition
      full <= 1;
      empty <= 0;
    end
  end
end

always @(posedge rd_clk) begin
  if (rst) begin // reset
    rd_ptr <= 0;
    count <= 0;
    full <= 0;
    empty <= 1;
  end else if (rd_en && !empty) begin // read
    rd_data <= buffer[rd_ptr];
    rd_ptr <= rd_ptr + 1;
    count <= count - 1;
    if (count == 0) begin // Check if the buffer is empty after read
      full <= 0;
      empty <= 1;
    end
  end
end

endmodule