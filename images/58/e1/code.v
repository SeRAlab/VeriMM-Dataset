module top_module(
  input clk,
  input rst,
  input [data_width-1:0] din,
  input wr_en,
  input rd_en,
  output reg [data_width-1:0] dout  // Change to reg type
);parameter data_width = 8;
  parameter depth = 16;

  reg [data_width-1:0] memory [0:depth-1];
  reg [4:0] top = 0;
  reg [4:0] bottom = 0;
  reg [4:0] count = 0;

  always @(posedge clk) begin
    if (rst) begin
      top <= 0;
      bottom <= 0;
      count <= 0;
    end else begin
      if (wr_en && count < depth) begin
        memory[top] <= din;
        top <= top + 1;
        count <= count + 1;
      end
      if (rd_en && count > 0) begin
        dout <= memory[bottom];
        bottom <= bottom + 1;
        count <= count - 1;
      end
    end
  end

endmodule