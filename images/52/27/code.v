module top_module (
    input [2:0] a,
    output reg [15:0] q
);  always @(*)
    case (a)
      0: q = 16'h7118;
      1: q = 16'h35ff;
      2: q = 16'h6334;
      3: q = 16'he847;
      4: q = 16'hc84f;
      5: q = 16'h0c7b;
      6: q = 16'hc470;
      7: q = 16'hd7a1;
    endcase

endmodule
