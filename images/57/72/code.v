module top_module(
  input clk, // clock signal
  input rst, // reset signal
  input [7:0] data_in, // input data
  input wr_en, // write enable signal
  output reg [7:0] data_out, // output data
  input rd_en, // read enable signal
  output full, // FIFO full signal
  output empty // FIFO empty signal
);parameter DEPTH = 8; // FIFO depth
  reg [7:0] mem [0:DEPTH-1]; // internal memory array
  reg [2:0] wr_ptr = 0; // write pointer
  reg [2:0] rd_ptr = 0; // read pointer
  reg [2:0] count = 0; // number of elements in the FIFO

  // combinational logic for full and empty signals
  assign full = (count == DEPTH);
  assign empty = (count == 0);

  // synchronous write operation
  always @(posedge clk) begin
    if (rst) begin
      wr_ptr <= 0;
      rd_ptr <= 0;
      count <= 0;
    end else if (wr_en && !full) begin
      mem[wr_ptr] <= data_in;
      wr_ptr <= wr_ptr + 1;
      count <= count + 1;
    end
  end

  // synchronous read operation
  always @(posedge clk) begin
    if (rst) begin
      wr_ptr <= 0;
      rd_ptr <= 0;
      count <= 0;
      data_out <= 8'b0; // reset data_out to zero on reset
    end else if (rd_en && !empty) begin
      data_out <= mem[rd_ptr];
      rd_ptr <= rd_ptr + 1;
      count <= count - 1;
    end
  end

endmodule