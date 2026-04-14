module top_module(input [15:0] addr, output [47:0] data);reg [47:0] rom [0:15]; 
  assign data = rom[addr]; 
  initial 
  begin 
  rom[0] = 48'h0000_0C00_0F03; 
  rom[1] = 48'h1014_0000_0000; 
  rom[2] = 48'h1018_0000_0001; 
  rom[3] = 48'h1010_0000_3418; 
  rom[4] = 48'h1000_0000_0010; 
  rom[5] = 48'h1010_0000_3518; 
  rom[6] = 48'hffff_ffff_ffff; 
  rom[7] = 48'hffff_ffff_ffff; 
  rom[8] = 48'hffff_ffff_ffff; 
  rom[9] = 48'hffff_ffff_ffff; 
  rom[10] = 48'hffff_ffff_ffff; 
  rom[11] = 48'hffff_ffff_ffff; 
  rom[12] = 48'hffff_ffff_ffff; 
  rom[13] = 48'hffff_ffff_ffff; 
  rom[14] = 48'hffff_ffff_ffff; 
  rom[15] = 48'hffff_ffff_ffff; 
  end 
 endmodule