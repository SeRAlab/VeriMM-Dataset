module top_module(
  input clk,
  input rst,
  input wr_en,
  input rd_en,
  input [7:0] data_in,
  output reg [7:0] data_out, // data_out should be a reg to store values.
  output reg full,           // Change full to reg.
  output reg empty           // Change empty to reg.
);localparam DEPTH = 8;

  reg [7:0] buffer [DEPTH-1:0];
  reg [2:0] wr_ptr;
  reg [2:0] rd_ptr;

  always @(posedge clk) begin
    if (rst) begin
      wr_ptr <= 0;
      rd_ptr <= 0;
      full <= 0;
      empty <= 1;
    end
    else begin
      if (wr_en && !full) begin
        buffer[wr_ptr] <= data_in;
        wr_ptr <= wr_ptr + 1;
        if (wr_ptr == DEPTH - 1) begin // Check for depth - 1 for wrap around.
          wr_ptr <= 0;
        end
        if (wr_ptr + 1 == rd_ptr) begin // Correct condition for fullness
          full <= 1;
        end
        empty <= 0;
      end
      if (rd_en && !empty) begin
        data_out <= buffer[rd_ptr];
        rd_ptr <= rd_ptr + 1;
        if (rd_ptr == DEPTH - 1) begin // Check for depth - 1 for wrap around.
          rd_ptr <= 0;
        end
        if (rd_ptr + 1 == wr_ptr) begin // Correct condition for emptiness
          empty <= 1;
        end
        full <= 0;
      end
    end
  end

endmodule