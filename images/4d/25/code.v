module top_module(
  clk,
  rst,
  din,
  wr_en,
  rd_en,
  dout,
  full,
  empty
);parameter DEPTH = 16;

input clk;
input rst;
input [7 : 0] din;
input wr_en;
input rd_en;
output reg [7 : 0] dout;  // Changed to reg type
output full;
output empty;

reg [7:0] mem [0:DEPTH-1];
reg [3:0] wr_ptr = 0;
reg [3:0] rd_ptr = 0;
reg [3:0] count = 0;

assign full = (count == DEPTH);
assign empty = (count == 0);

always @(posedge clk or posedge rst) begin
  if (rst) begin
    wr_ptr <= 0;
    rd_ptr <= 0;
    count <= 0;
    dout <= 0;  // Initialize dout in reset condition
  end else begin
    if (wr_en && !full) begin
      mem[wr_ptr] <= din;
      wr_ptr <= wr_ptr + 1;
      count <= count + 1;
    end
    if (rd_en && !empty) begin
      dout <= mem[rd_ptr];  // This is now valid since dout is reg
      rd_ptr <= rd_ptr + 1;
      count <= count - 1;
    end
  end
end

endmodule