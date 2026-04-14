module top_module(
  input [n-1:0] addr,
  output [m-1:0] data
);parameter n = 8; // number of address bits
parameter m = 16; // number of data bits
parameter num_words = 256; // number of words in the ROM
parameter word_size = 16; // size of each word in bits

reg [m-1:0] rom [0:num_words-1]; // declare the ROM

// initialize the ROM with pre-programmed data values
initial begin
  rom[0] = 16'h0000;
  rom[1] = 16'h0001;
  rom[2] = 16'h0002;
  // add more data values as needed
end

// output the data value that corresponds to the input address
assign data = rom[addr];

endmodule