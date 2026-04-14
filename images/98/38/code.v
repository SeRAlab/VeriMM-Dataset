module top_module(x, y, z, w);parameter VAL_X = 0;
  parameter VAL_Y = 0;
  parameter VAL_Z = 0;
  parameter VAL_W = 0;

  output var x;
  output var [7:0] y;
  output var signed [7:0] z;
  output var logic [7:0] w;

  assign x = VAL_X;
  assign y = VAL_Y;
  assign z = VAL_Z;
  assign w = VAL_W;

endmodule