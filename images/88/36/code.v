module top_module(
  input [depth-1:0] address,
  input [data_width-1:0] data_in,
  input write_en,
  output reg [data_width-1:0] data_out
);parameter data_width = 8; // number of bits in each data word
parameter depth = 16; // number of words that can be stored in the memory block

reg [data_width-1:0] mem [0:depth-1]; // array of data words with depth elements, each with data_width bits

// read or write data to the memory block at the specified address
always @(*) begin
  if (write_en) // write data to memory block
    mem[address] = data_in;
  else // read data from memory block
    data_out = mem[address];
end

endmodule