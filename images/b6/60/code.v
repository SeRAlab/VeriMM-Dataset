module top_module(
  clk, rd_en, rst, empty, wr_en, full, dout, din
);input clk;
  input rd_en;
  input rst;
  output empty;
  input wr_en;
  output full;
  output reg [31 : 0] dout; // Changed to reg type
  input [31 : 0] din;

  reg [31:0] mem [511:0];
  reg [8:0] rd_pointer = 0;
  reg [8:0] wr_pointer = 0;
  reg [8:0] count = 0;

  assign empty = (count == 0);
  assign full = (count == 512);

  always @(posedge clk) begin
    if (rst) begin
      rd_pointer <= 0;
      wr_pointer <= 0;
      count <= 0;
    end else begin
      if (wr_en && !full) begin
        mem[wr_pointer] <= din;
        wr_pointer <= wr_pointer + 1;
        count <= count + 1;
      end

      if (rd_en && !empty) begin
        dout <= mem[rd_pointer];
        rd_pointer <= rd_pointer + 1;
        count <= count - 1;
      end
    end
  end

endmodule