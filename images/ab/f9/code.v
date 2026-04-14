module top_module (
    input [2:0] a,
    output reg [15:0] q
);  always @(*)
    case (a)
      0: q = 16'h2a84;
      1: q = 16'h9ec7;
      2: q = 16'habdf;
      3: q = 16'h809a;
      4: q = 16'hb32b;
      5: q = 16'hceb7;
      6: q = 16'h86ce;
      7: q = 16'hea47;
    endcase

endmodule
