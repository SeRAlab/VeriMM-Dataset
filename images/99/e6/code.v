module top_module(
  input clk,
  input we1,
  input we2,
  input [width-1:0] din1,
  input [width-1:0] din2,
  input [addr_width-1:0] addr1,
  input [addr_width-1:0] addr2,
  output reg [width-1:0] dout1,
  output reg [width-1:0] dout2
);parameter width = 8; // data bus width
parameter depth = 256; // memory depth
parameter addr_width = $clog2(depth); // address width calculation

reg [width-1:0] mem [0:depth-1];

always @(posedge clk) begin
  if (we1) mem[addr1] <= din1;
  if (we2) mem[addr2] <= din2;
  dout1 <= mem[addr1];
  dout2 <= mem[addr2];
end

endmodule