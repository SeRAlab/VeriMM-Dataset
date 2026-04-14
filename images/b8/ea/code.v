module top_module(input wire [10:0] di,output wire [4:0] crc_out);wire [10:0] d = { di[0], di[1], di[2], di[3], di[4], 
  di[5], di[6], di[7], di[8], di[9], 
  di[10] }; 
 wire [4:0] c = 5'h1F; 
 wire [4:0] q = { ^d[10:9] ^ ^d[6:5] ^ d[3] ^ d[0] ^ c[0] ^ ^c[4:3], 
  d[10] ^ ^d[7:6] ^ d[4] ^ d[1] ^ ^c[1:0] ^ c[4], 
  ^d[10:7] ^ d[6] ^ ^d[3:2] ^ d[0] ^ ^c[4:0], 
  ^d[10:7] ^^ d[4:3] ^ d[1] ^ ^c[4:1], 
  ^d[10:8] ^ ^d[5:4] ^ d[2] ^ ^c[4:2] }; 
 assign crc_out = ~q; 
 endmodule