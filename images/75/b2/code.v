module top_module(
  input [n-1:0] addr,
  output [m-1:0] data
);parameter n = 3; // number of address signals
parameter m = 8; // number of data signals
parameter d = 8; // number of data words
parameter w = 8; // number of bits per data word

reg [w-1:0] rom [0:d-1];

initial begin
  // Initialize the ROM with data words
  rom[0] = 8'b00000000;
  rom[1] = 8'b00000001;
  rom[2] = 8'b00000010;
  rom[3] = 8'b00000011;
  rom[4] = 8'b00000100;
  rom[5] = 8'b00000101;
  rom[6] = 8'b00000110;
  rom[7] = 8'b00000111;
end

assign data = rom[addr];

endmodule