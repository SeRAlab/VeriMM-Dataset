module top_module(
  input [n-1:0] data_in,
  input [addr_width-1:0] address,
  input write_en,
  input clk,
  output reg [n-1:0] data_out
);parameter n = 8; // number of bits in data_in and data_out
parameter depth = 256; // depth of the RAM block (i.e., number of memory locations)

localparam addr_width = $clog2(depth); // calculate address width based on depth
reg [n-1:0] memory [0:depth-1]; // define memory array

always @(posedge clk) begin
  if (write_en) begin
    memory[address] <= data_in; // write data to memory
  end
  data_out <= memory[address]; // read data from memory
end

endmodule