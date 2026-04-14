module top_module(clk, rst, en, wr_data, rd_data, full, empty);parameter WIDTH = 8;
  parameter DEPTH = 8;

  input clk, rst, en;
  input [WIDTH-1:0] wr_data;
  output reg [WIDTH-1:0] rd_data; // Changed to reg
  output reg full, empty; // Changed to reg

  reg [WIDTH-1:0] mem [0:DEPTH-1];
  reg [2:0] wr_ptr, rd_ptr;
  reg [2:0] count;

  always @(posedge clk) begin
    if (rst) begin
      count <= 0;
      wr_ptr <= 0;
      rd_ptr <= 0;
      full <= 0;
      empty <= 1;
    end else if (en) begin
      if (count == DEPTH) begin
        full <= 1;
        empty <= 0;
      end else if (count == 0) begin
        full <= 0;
        empty <= 1;
      end else begin
        full <= 0;
        empty <= 0;
      end

      if (~full) begin
        mem[wr_ptr] <= wr_data;
        wr_ptr <= wr_ptr + 1;
        count <= count + 1;
      end

      if (~empty) begin
        rd_data <= mem[rd_ptr];
        rd_ptr <= rd_ptr + 1;
        count <= count - 1;
      end
    end
  end

endmodule