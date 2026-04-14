module top_module (
    input [2:0] a,
    output reg [15:0] q
);  always @(*)
    case (a)
      0: q = 16'h89af;
      1: q = 16'hd1bf;
      2: q = 16'h376a;
      3: q = 16'h4178;
      4: q = 16'h1c46;
      5: q = 16'hd55b;
      6: q = 16'hc75c;
      7: q = 16'h4b4b;
    endcase

endmodule
