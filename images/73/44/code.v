module top_module(phy, one_count, z);input phy;
  input [1:0] one_count;

  output [1:0] z;
  reg [1:0] z;
  

  always @(phy or one_count)
    if (phy)
      z = one_count + 1;

endmodule