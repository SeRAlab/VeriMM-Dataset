module comparator (input [3:0] V, output z);

  assign z = (V[3] & (V[2] | V[1]));

endmodule