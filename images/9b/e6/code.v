module top_module(
  input clk,
  input reset_n,
  input wr,
  input [31:0] wr_data,
  input rd,
  output [31:0] rd_data,
  output empty,
  output full
);parameter FIFO_DEPTH = 4;

  reg [31:0] buffer [FIFO_DEPTH-1:0];
  reg [1:0] wr_ptr = 2'b00;
  reg [1:0] rd_ptr = 2'b00;
  reg [2:0] count = 3'b000;
  wire [1:0] next_wr_ptr;
  wire [1:0] next_rd_ptr;
  wire [2:0] next_count;

  assign empty = (count == 0);
  assign full = (count == FIFO_DEPTH);

  assign rd_data = buffer[rd_ptr];

  always @ (posedge clk) begin
    if (!reset_n) begin
      wr_ptr <= 2'b00;
      rd_ptr <= 2'b00;
      count <= 3'b000;
    end else begin
      if (wr && !full) begin
        buffer[wr_ptr] <= wr_data;
        wr_ptr <= next_wr_ptr;
        count <= next_count;
      end
      if (rd && !empty) begin
        rd_ptr <= next_rd_ptr;
        count <= next_count;
      end
    end
  end

  assign next_wr_ptr = (count < FIFO_DEPTH) ? ((wr_ptr == 2'b11) ? 2'b00 : wr_ptr + 1) : wr_ptr;
  assign next_rd_ptr = (count > 0) ? ((rd_ptr == 2'b11) ? 2'b00 : rd_ptr + 1) : rd_ptr;
  assign next_count = count + wr - rd;

endmodule