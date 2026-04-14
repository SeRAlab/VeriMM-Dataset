module top_module(
  input [3:0] data,
  output reg parity
);assign parity = ~(data[0] ^ data[1] ^ data[2] ^ data[3]);
  
endmodule