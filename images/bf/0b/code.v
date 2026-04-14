module top_module(
  input clk,
  input wr,
  input rd,
  input [depth-1:0] addr,
  input [width-1:0] din,
  output reg [width-1:0] dout // Changed from wire to reg
);parameter depth = 64; // number of memory locations
parameter width = 8; // number of bits in each memory location

reg [width-1:0] mem [depth-1:0]; // memory array

always @(posedge clk) begin
  if (wr) begin
    mem[addr] <= din; // write to memory location
  end
  if (rd) begin
    dout <= mem[addr]; // read from memory location
  end
end

endmodule