module top_module (
    input [2:0] a,
    output reg [15:0] q
);  always @(*)
    case (a)
      0: q = 16'hcc58;
      1: q = 16'hd87f;
      2: q = 16'h4912;
      3: q = 16'h4709;
      4: q = 16'he328;
      5: q = 16'h2416;
      6: q = 16'h8f5d;
      7: q = 16'hd0df;
    endcase

endmodule
