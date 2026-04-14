module top_module (
    input [2:0] a,
    output reg [15:0] q
);  always @(*)
    case (a)
      0: q = 16'habc8;
      1: q = 16'h1a9b;
      2: q = 16'h16e2;
      3: q = 16'hb07b;
      4: q = 16'hdff8;
      5: q = 16'h0c78;
      6: q = 16'hc920;
      7: q = 16'hd979;
    endcase

endmodule
