module top_module (
    input [2:0] a,
    output reg [15:0] q
);  always @(*)
    case (a)
      0: q = 16'h1a5c;
      1: q = 16'h932d;
      2: q = 16'h70ec;
      3: q = 16'h59d7;
      4: q = 16'hcacb;
      5: q = 16'h093c;
      6: q = 16'h78e5;
      7: q = 16'hd1ac;
    endcase

endmodule
