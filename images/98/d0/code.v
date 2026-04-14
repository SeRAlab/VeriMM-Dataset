module top_module(
  input [k-1:0] addr,
  output [n-1:0] data
);parameter k = 8; // number of address bits
parameter n = 16; // number of data bits
parameter m = 256; // number of words (i.e., the number of data entries)

// Define the data entries for the ROM
reg [n-1:0] rom_data [0:m-1];
initial begin
  // Initialize the ROM data entries
  // Example initialization for a 256x16 mask ROM
  rom_data[0] = 16'h1234;
  rom_data[1] = 16'h5678;
  // ...
  rom_data[255] = 16'hABCD;
end

// Connect the input address to the output data
assign data = rom_data[addr];

endmodule