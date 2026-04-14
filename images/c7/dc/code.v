module check_tuple(
  input [2:0] tuple,
  output valid
);

  wire a = tuple[0] ^ tuple[1];
  wire b = tuple[1] ^ tuple[2];
  wire c = tuple[0] ^ tuple[2];
  
  assign valid = (a == tuple[2]) && (b == tuple[0]) && (c == tuple[1]);

endmodule