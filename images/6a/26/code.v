module top_module(D, x, y, V);input [0:3] D;
  wire [0:3] D;

  output x, y, V;
  wire x, y, V;

  wire w1;

  assign w1 = (~D[2]) & D[1];

  assign x = D[3] | D[2];
  assign y = D[3] | w1;

  assign V = x | D[1] | D[0];

endmodule