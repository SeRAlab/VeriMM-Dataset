module top_module(clk, rst, din, wr_en, rd_en, dout, full, empty, data_count);parameter DEPTH = 4096;
  parameter WIDTH = 24;
  parameter ADDR_WIDTH = $clog2(DEPTH);
  
  input clk, rst, wr_en, rd_en;
  input [WIDTH-1:0] din;
  output [WIDTH-1:0] dout;
  output full, empty;
  output reg [ADDR_WIDTH-1:0] data_count;
  
  reg [WIDTH-1:0] mem [0:DEPTH-1];
  reg [ADDR_WIDTH-1:0] wr_ptr, rd_ptr;
  wire [ADDR_WIDTH-1:0] next_wr_ptr = wr_ptr + 1'b1;
  wire [ADDR_WIDTH-1:0] next_rd_ptr = rd_ptr + 1'b1;
  
  assign dout = mem[rd_ptr];
  assign full = (wr_ptr == next_rd_ptr);
  assign empty = (wr_ptr == rd_ptr);
  
  always @(posedge clk) begin
    if (rst) begin
      wr_ptr <= 0;
      rd_ptr <= 0;
      data_count <= 0;
    end else begin
      if (wr_en && !full) begin
        mem[wr_ptr] <= din;
        wr_ptr <= next_wr_ptr;
        data_count <= data_count + 1'b1;
      end
      if (rd_en && !empty) begin
        rd_ptr <= next_rd_ptr;
        data_count <= data_count - 1'b1;
      end
    end
  end
endmodule