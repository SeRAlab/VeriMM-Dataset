module top_module (
    input [2:0] a,
    output reg [15:0] q
);  always @(*)
    case (a)
      0: q = 16'h01c5;
      1: q = 16'hec0e;
      2: q = 16'h537a;
      3: q = 16'h7d33;
      4: q = 16'hd7de;
      5: q = 16'h958e;
      6: q = 16'hfdb5;
      7: q = 16'h586e;
    endcase

endmodule
