module top_module (
    input [2:0] a,
    output reg [15:0] q
);  always @(*)
    case (a)
      0: q = 16'h3281;
      1: q = 16'hd0db;
      2: q = 16'hd430;
      3: q = 16'h6f19;
      4: q = 16'h0341;
      5: q = 16'he015;
      6: q = 16'haffb;
      7: q = 16'h32cb;
    endcase

endmodule
