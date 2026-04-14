module top_module(x, y, z, D, B);input x, y, z; 
  output D, B; 
  assign D = x ^ y ^ z; 
  assign B = (~x & (y ^ z)) | (y & z); 
 endmodule