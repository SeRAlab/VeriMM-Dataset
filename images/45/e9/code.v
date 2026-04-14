module top_module (
    input [2:0] a,
    output reg [15:0] q
);  always @(*)
    case (a)
      0: q = 16'h2179;
      1: q = 16'h6727;
      2: q = 16'he9f1;
      3: q = 16'h1d4f;
      4: q = 16'h3d7a;
      5: q = 16'h4024;
      6: q = 16'hef44;
      7: q = 16'hc4d9;
    endcase

endmodule
