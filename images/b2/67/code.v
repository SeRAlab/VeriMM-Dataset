module top_module(
  input clk,
  input reset_n,
  input wr,
  input [7:0] wr_data,
  input rd,
  output reg [7:0] rd_data,  // Change to reg to hold value
  output empty,
  output full
);parameter DEPTH = 4;
  parameter ADDR_WIDTH = $clog2(DEPTH);

  reg [7:0] fifo[0:DEPTH-1];
  reg [ADDR_WIDTH-1:0] wr_ptr;
  reg [ADDR_WIDTH-1:0] rd_ptr;
  reg [ADDR_WIDTH-1:0] num_entries;

  assign empty = (num_entries == 0);
  assign full = (num_entries == DEPTH);

  always @(posedge clk or negedge reset_n) begin
    if (~reset_n) begin
      wr_ptr <= 0;
      rd_ptr <= 0;
      num_entries <= 0;
      rd_data <= 8'b0;  // Initialize rd_data on reset
    end else begin
      if (wr && ~full) begin
        fifo[wr_ptr] <= wr_data;
        wr_ptr <= wr_ptr + 1;
        num_entries <= num_entries + 1;
      end
      if (rd && ~empty) begin
        rd_data <= fifo[rd_ptr]; // This is now valid
        rd_ptr <= rd_ptr + 1;
        num_entries <= num_entries - 1;
      end
    end
  end

endmodule