module top_module(
  input clk,
  input rst,
  input wr_en,
  input rd_en,
  input [width-1:0] data_in,
  output reg [width-1:0] data_out,  // Changed to reg to hold data
  output full,
  output empty
);parameter width = 8; // width of the data (in bits)
parameter depth = 16; // depth of the FIFO

reg [width-1:0] fifo[depth-1:0]; // storage array
reg [$clog2(depth)-1:0] wr_ptr = 0; // write pointer
reg [$clog2(depth)-1:0] rd_ptr = 0; // read pointer
wire [$clog2(depth)-1:0] next_wr_ptr = wr_ptr + 1; // next write pointer
wire [$clog2(depth)-1:0] next_rd_ptr = rd_ptr + 1; // next read pointer

assign full = (next_wr_ptr == rd_ptr); // full signal
assign empty = (wr_ptr == rd_ptr); // empty signal

always @(posedge clk) begin
  if (rst) begin
    wr_ptr <= 0;
    rd_ptr <= 0;
  end else begin
    if (wr_en && !full) begin
      fifo[wr_ptr] <= data_in;
      wr_ptr <= next_wr_ptr;
    end
    if (rd_en && !empty) begin
      data_out <= fifo[rd_ptr];
      rd_ptr <= next_rd_ptr;
    end
  end
end

endmodule