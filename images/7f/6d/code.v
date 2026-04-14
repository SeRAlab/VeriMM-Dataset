module top_module (
    input [2:0] a,
    output reg [15:0] q
);  always @(*)
    case (a)
      0: q = 16'hda04;
      1: q = 16'ha482;
      2: q = 16'ha9ba;
      3: q = 16'hc756;
      4: q = 16'hc4f2;
      5: q = 16'h791b;
      6: q = 16'h34fd;
      7: q = 16'h108e;
    endcase

endmodule
