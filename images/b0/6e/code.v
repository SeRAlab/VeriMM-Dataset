module top_module(
  input [n-1:0] addr,
  input write_en,
  input [width-1:0] data_in,
  input clk,
  output reg [width-1:0] data_out // Change output to reg type
);parameter n = 8; // number of address lines
parameter width = 16; // number of bits stored in each memory location
parameter depth = 256; // number of memory locations

reg [width-1:0] mem [0:depth-1]; // define memory array

always @(posedge clk) begin
  if (write_en) begin
    mem[addr] <= data_in; // write data to memory location specified by address
  end
  else begin
    data_out <= mem[addr]; // read data from memory location specified by address
  end
end

endmodule