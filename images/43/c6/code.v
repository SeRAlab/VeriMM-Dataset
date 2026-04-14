module top_module(
  input [n-1:0] addr,
  output [m-1:0] data
);parameter n = 8; // number of bits in the address signal
parameter m = 16; // number of bits in the data signal
parameter data_width = 8; // width of the data word
parameter depth = 256; // depth of the ROM

reg [data_width-1:0] rom [0:depth-1]; // define the ROM as an array of data words

initial begin // initialize the ROM with the fixed pattern of data
  rom[0] = 8'h00;
  rom[1] = 8'h01;
  rom[2] = 8'h02;
  // ...
  rom[depth-1] = 8'hFF;
end

assign data = rom[addr]; // retrieve the data word from the ROM using the input address signal

endmodule