module top_module(
  input [15:0] data_in,
  output [16:0] data_out_with_parity
);wire parity_bit;
  
  assign parity_bit = data_in[0] ^ data_in[1] ^ data_in[2] ^ data_in[3] ^ data_in[4] ^ data_in[5] ^ data_in[6] ^ data_in[7] ^ data_in[8] ^ data_in[9] ^ data_in[10] ^ data_in[11] ^ data_in[12] ^ data_in[13] ^ data_in[14] ^ data_in[15];
  
  assign data_out_with_parity = {parity_bit, data_in};
  
endmodule