module top_module(
  input clk,
  input en,
  input wr,
  input [addr_width-1:0] addr,
  input [width-1:0] din,
  output reg [width-1:0] dout // Changed from wire to reg
);parameter depth = 1024; // number of memory locations
parameter width = 8; // width of each memory location
parameter addr_width = $clog2(depth); // Calculate address width using $clog2

reg [width-1:0] mem [0:depth-1]; // array of registers to store memory locations

always @(posedge clk) begin
  if (en) begin
    dout <= mem[addr];
  end
  if (wr) begin
    mem[addr] <= din;
  end
end

endmodule