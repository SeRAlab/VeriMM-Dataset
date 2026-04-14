module top_module(
  input [99:0] data_in,
  output reg out_and,
  output reg out_or,
  output reg out_xor
);wire [99:0] nor_out;
  
  // Perform NOR operation on all bits of data_in
  assign nor_out = ~data_in;
  
  // Perform AND operation on all bits of nor_out
  assign out_and = ~|nor_out;
  
  // Perform OR operation on all bits of nor_out
  assign out_or = ~&nor_out;
  
  // Perform XOR operation on all bits of nor_out
  assign out_xor = ~(nor_out[99]^nor_out[98]^nor_out[97]^nor_out[96]^nor_out[95]^nor_out[94]^nor_out[93]^nor_out[92]^nor_out[91]^nor_out[90]^nor_out[89]^nor_out[88]^nor_out[87]^nor_out[86]^nor_out[85]^nor_out[84]^nor_out[83]^nor_out[82]^nor_out[81]^nor_out[80]^nor_out[79]^nor_out[78]^nor_out[77]^nor_out[76]^nor_out[75]^nor_out[74]^nor_out[73]^nor_out[72]^nor_out[71]^nor_out[70]^nor_out[69]^nor_out[68]^nor_out[67]^nor_out[66]^nor_out[65]^nor_out[64]^nor_out[63]^nor_out[62]^nor_out[61]^nor_out[60]^nor_out[59]^nor_out[58]^nor_out[57]^nor_out[56]^nor_out[55]^nor_out[54]^nor_out[53]^nor_out[52]^nor_out[51]^nor_out[50]^nor_out[49]^nor_out[48]^nor_out[47]^nor_out[46]^nor_out[45]^nor_out[44]^nor_out[43]^nor_out[42]^nor_out[41]^nor_out[40]^nor_out[39]^nor_out[38]^nor_out[37]^nor_out[36]^nor_out[35]^nor_out[34]^nor_out[33]^nor_out[32]^nor_out[31]^nor_out[30]^nor_out[29]^nor_out[28]^nor_out[27]^nor_out[26]^nor_out[25]^nor_out[24]^nor_out[23]^nor_out[22]^nor_out[21]^nor_out[20]^nor_out[19]^nor_out[18]^nor_out[17]^nor_out[16]^nor_out[15]^nor_out[14]^nor_out[13]^nor_out[12]^nor_out[11]^nor_out[10]^nor_out[9]^nor_out[8]^nor_out[7]^nor_out[6]^nor_out[5]^nor_out[4]^nor_out[3]^nor_out[2]^nor_out[1]^nor_out[0]);
  
endmodule