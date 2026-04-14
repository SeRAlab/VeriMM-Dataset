module top_module (
    input [2:0] a,
    output reg [15:0] q
);  always @(*)
    case (a)
      0: q = 16'haff3;
      1: q = 16'hfc9b;
      2: q = 16'ha95c;
      3: q = 16'hcc2f;
      4: q = 16'h4eae;
      5: q = 16'h6731;
      6: q = 16'h0f10;
      7: q = 16'h174c;
    endcase

endmodule
