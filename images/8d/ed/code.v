module top_module(
  input [11:0] din,
  input wr_en,
  input rd_en,
  input clk,
  input srst,
  output [11:0] dout,
  output empty,
  output full
);parameter DEPTH = 1024;
  parameter WIDTH = 12;

  reg [WIDTH-1:0] ram [0:DEPTH-1];
  reg [WIDTH-1:0] dout_reg;
  reg [WIDTH-1:0] wr_ptr = 0;
  reg [WIDTH-1:0] rd_ptr = 0;
  reg empty_reg;
  reg full_reg;

  always @(posedge clk or negedge srst) begin
    if (~srst) begin
      wr_ptr <= 0;
      rd_ptr <= 0;
      empty_reg <= 1;
      full_reg <= 0;
    end else begin
      if (wr_en && ~full_reg) begin
        ram[wr_ptr] <= din;
        wr_ptr <= wr_ptr + 1;
        if (wr_ptr == DEPTH-1) begin
          wr_ptr <= 0;
        end
        if (wr_ptr == rd_ptr) begin
          full_reg <= 1;
        end
        empty_reg <= 0;
      end
      if (rd_en && ~empty_reg) begin
        dout_reg <= ram[rd_ptr];
        rd_ptr <= rd_ptr + 1;
        if (rd_ptr == DEPTH-1) begin
          rd_ptr <= 0;
        end
        if (rd_ptr == wr_ptr) begin
          empty_reg <= 1;
        end
        full_reg <= 0;
      end
    end
  end

  assign dout = dout_reg;
  assign empty = empty_reg;
  assign full = full_reg;

endmodule