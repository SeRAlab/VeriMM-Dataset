module top_module(
  output reg [63:0] dout,
  output reg empty,
  output reg full,
  input wr_en,
  input rd_en,
  input clk,
  input srst,
  input [63:0] din
);reg [5:0] wr_ptr;
  reg [5:0] rd_ptr;
  reg [5:0] count;

  reg [63:0] ram [15:0];

  always @(posedge clk) begin
    if (srst) begin
      wr_ptr <= 0;
      rd_ptr <= 0;
      count <= 0;
      empty <= 1;
      full <= 0;
    end else begin
      if (wr_en && !full) begin
        ram[wr_ptr] <= din;
        wr_ptr <= wr_ptr + 1;
        count <= count + 1;
        empty <= 0;
        if (count == 16) full <= 1;
      end
      if (rd_en && !empty) begin
        dout <= ram[rd_ptr];
        rd_ptr <= rd_ptr + 1;
        count <= count - 1;
        full <= 0;
        if (count == 1) empty <= 1;
      end
    end
  end

endmodule