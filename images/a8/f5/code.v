module top_module (
    input [2:0] a,
    output reg [15:0] q
);  always @(*)
    case (a)
      0: q = 16'h2aa4;
      1: q = 16'hc47a;
      2: q = 16'hde3b;
      3: q = 16'h6fca;
      4: q = 16'h7bb6;
      5: q = 16'h6347;
      6: q = 16'hd7bd;
      7: q = 16'h92e4;
    endcase

endmodule
