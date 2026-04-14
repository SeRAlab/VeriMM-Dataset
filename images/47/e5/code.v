module top_module(
  output reg wr_rst_busy,
  output reg [63:0] dout,
  output reg empty,
  output reg full,
  input rd_en,
  input wr_en,
  input clk,
  input [63:0] din,
  input rst
);reg [9:0] wr_pntr;
  reg [9:0] rd_pntr;
  reg [63:0] ram [0:1023];
  reg [9:0] count;

  always @(posedge clk) begin
    if (rst) begin
      wr_pntr <= 10'd0;
      rd_pntr <= 10'd0;
      count <= 10'd0;
      empty <= 1'b1;
      full <= 1'b0;
      wr_rst_busy <= 1'b0;
    end else begin
      if (wr_en && !full) begin
        ram[wr_pntr] <= din;
        wr_pntr <= wr_pntr + 1;
        count <= count + 1;
        empty <= 1'b0;
        if (wr_pntr == 10'd1023) full <= 1'b1;
      end
      if (rd_en && !empty) begin
        dout <= ram[rd_pntr];
        rd_pntr <= rd_pntr + 1;
        count <= count - 1;
        full <= 1'b0;
        if (rd_pntr == 10'd1023) empty <= 1'b1;
      end
      wr_rst_busy <= wr_en || rst;
    end
  end

endmodule