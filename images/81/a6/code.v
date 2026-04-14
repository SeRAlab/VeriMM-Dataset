module top_module( clock, address, rom_enable, data );input [5:0] address;
  output [7:0] data;
  input clock, rom_enable;
  wire   rom_enable;
  assign data[7] = rom_enable;

endmodule