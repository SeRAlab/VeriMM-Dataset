module top_module(z, SSD);input z;
  output [0:6] SSD;

  assign SSD[0] = z;
  assign SSD[1:2] = 2'b00;
  assign SSD[3:5] = {3{z}};
  assign SSD[6] = 1;
endmodule