module top_module(
  input clk,
  input [addr_width-1:0] addr1,
  input [addr_width-1:0] addr2,
  input we1,
  input we2,
  input [width-1:0] din1,
  input [width-1:0] din2,
  output reg [width-1:0] dout1,
  output reg [width-1:0] dout2
);parameter depth = 256; // number of memory locations
parameter width = 8; // width of each memory location in bits
localparam addr_width = $clog2(depth); // calculate address width using $clog2

reg [width-1:0] mem [0:depth-1];

always @(posedge clk) begin
  if (we1) begin
    mem[addr1] <= din1;
  end
  if (we2) begin
    mem[addr2] <= din2;
  end
  dout1 <= mem[addr1];
  dout2 <= mem[addr2];
end

endmodule