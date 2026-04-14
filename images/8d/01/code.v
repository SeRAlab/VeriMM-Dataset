module top_module(
  input  [31:0] in_bits,
  output        out_val,
  output  [4:0] out_bits
);assign out_val = ( in_bits != 32'b0 );

  

  assign out_bits =
    ( in_bits[ 0] ) ? 5'b00000
  : ( in_bits[ 1] ) ? 5'b00001
  : ( in_bits[ 2] ) ? 5'b00010
  : ( in_bits[ 3] ) ? 5'b00011
  : ( in_bits[ 4] ) ? 5'b00100
  : ( in_bits[ 5] ) ? 5'b00101
  : ( in_bits[ 6] ) ? 5'b00110
  : ( in_bits[ 7] ) ? 5'b00111
  : ( in_bits[ 8] ) ? 5'b01000
  : ( in_bits[ 9] ) ? 5'b01001
  : ( in_bits[10] ) ? 5'b01010
  : ( in_bits[11] ) ? 5'b01011
  : ( in_bits[12] ) ? 5'b01100
  : ( in_bits[13] ) ? 5'b01101
  : ( in_bits[14] ) ? 5'b01110
  : ( in_bits[15] ) ? 5'b01111
  : ( in_bits[16] ) ? 5'b10000
  : ( in_bits[17] ) ? 5'b10001
  : ( in_bits[18] ) ? 5'b10010
  : ( in_bits[19] ) ? 5'b10011
  : ( in_bits[20] ) ? 5'b10100
  : ( in_bits[21] ) ? 5'b10101
  : ( in_bits[22] ) ? 5'b10110
  : ( in_bits[23] ) ? 5'b10111
  : ( in_bits[24] ) ? 5'b11000
  : ( in_bits[25] ) ? 5'b11001
  : ( in_bits[26] ) ? 5'b11010
  : ( in_bits[27] ) ? 5'b11011
  : ( in_bits[28] ) ? 5'b11100
  : ( in_bits[29] ) ? 5'b11101
  : ( in_bits[30] ) ? 5'b11110
  : ( in_bits[31] ) ? 5'b11111
  :                   5'b00000;

endmodule