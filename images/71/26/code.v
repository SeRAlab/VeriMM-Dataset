module top_module (
    input [2:0] a,
    output reg [15:0] q
);  always @(*)
    case (a)
      0: q = 16'hc4d1;
      1: q = 16'h3c1e;
      2: q = 16'h661a;
      3: q = 16'h2503;
      4: q = 16'h0be7;
      5: q = 16'he3e7;
      6: q = 16'h13de;
      7: q = 16'h27be;
    endcase

endmodule
