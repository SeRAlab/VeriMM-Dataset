module top_module(
  input clk,
  input rd,
  input reset_n,
  input wr,
  input [31:0] wr_data,
  output almost_empty,
  output almost_full,
  output empty,
  output full,
  output reg [31:0] rd_data  // Changed `output` to `output reg`
);parameter WIDTH = 32;
  parameter DEPTH = 2;

  reg [WIDTH-1:0] buffer [DEPTH-1:0];
  reg [DEPTH-1:0] rd_ptr;
  reg [DEPTH-1:0] wr_ptr;
  reg [DEPTH-1:0] entries;

  assign full = entries == DEPTH;
  assign empty = entries == 0;
  assign almost_full = entries == DEPTH-1;
  assign almost_empty = entries == 1;

  always @(posedge clk) begin
    if (!reset_n) begin
      rd_ptr <= 2'b0;
      wr_ptr <= 2'b0;
      entries <= 2'b0;
      rd_data <= 32'b0;  // Initialize rd_data on reset
    end
    else begin
      if (wr && !full) begin
        buffer[wr_ptr] <= wr_data;
        wr_ptr <= wr_ptr + 1;
        entries <= entries + 1;
      end
      if (rd && !empty) begin
        rd_data <= buffer[rd_ptr];
        rd_ptr <= rd_ptr + 1;
        entries <= entries - 1;
      end
    end
  end

endmodule