module top_module(
  input [n-1:0] addr,
  output [m-1:0] data
);parameter n = 4; // number of address signals
parameter m = 2; // number of data signals
parameter width = 8; // width of each data signal (in bits)
parameter depth = 16; // depth of the ROM (i.e., number of data words stored)

reg [width-1:0] rom[0:depth-1]; // array of data words

initial begin
  // initialize the ROM with data words
  rom[0] = 8'h00;
  rom[1] = 8'h01;
  rom[2] = 8'h02;
  rom[3] = 8'h03;
  rom[4] = 8'h04;
  rom[5] = 8'h05;
  rom[6] = 8'h06;
  rom[7] = 8'h07;
  rom[8] = 8'h08;
  rom[9] = 8'h09;
  rom[10] = 8'h0A;
  rom[11] = 8'h0B;
  rom[12] = 8'h0C;
  rom[13] = 8'h0D;
  rom[14] = 8'h0E;
  rom[15] = 8'h0F;
end

assign data = rom[addr]; // output the data word at the indexed address

endmodule