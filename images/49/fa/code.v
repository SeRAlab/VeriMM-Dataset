module top_module(
  input clk,
  input wr,
  input rd,
  input reset_n,
  input [7:0] wr_data,
  output reg [7:0] rd_data,  // Changed from wire to reg
  output empty,
  output full,
  output almost_empty,
  output almost_full
);reg [7:0] buffer [1:0];
  reg [1:0] wr_ptr;
  reg [1:0] rd_ptr;
  wire [1:0] next_wr_ptr = (wr_ptr == 2'b11) ? 2'b00 : (wr_ptr + 1);
  wire [1:0] next_rd_ptr = (rd_ptr == 2'b11) ? 2'b00 : (rd_ptr + 1);

  assign empty = (wr_ptr == rd_ptr);
  assign full = (next_wr_ptr == rd_ptr);
  assign almost_empty = ((wr_ptr == next_rd_ptr) && !empty);
  assign almost_full = ((next_wr_ptr == rd_ptr) && !full);

  always @(posedge clk or negedge reset_n) begin
    if (!reset_n) begin
      buffer[1] <= 8'b0;
      buffer[0] <= 8'b0;
      wr_ptr <= 2'b00;
      rd_ptr <= 2'b00;
      rd_data <= 8'b0; // Initialize rd_data
    end else begin
      if (wr && !full) begin
        buffer[wr_ptr] <= wr_data;
        wr_ptr <= next_wr_ptr;
      end
      if (rd && !empty) begin
        rd_data <= buffer[rd_ptr]; // This assignment is valid now
        rd_ptr <= next_rd_ptr;
      end
    end
  end

endmodule