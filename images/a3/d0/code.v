module top_module (
    input [2:0] a,
    output reg [15:0] q
);  always @(*)
    case (a)
      0: q = 16'hcc87;
      1: q = 16'h6c81;
      2: q = 16'h5f00;
      3: q = 16'hbbc9;
      4: q = 16'h27bb;
      5: q = 16'h6e76;
      6: q = 16'he912;
      7: q = 16'hc54d;
    endcase

endmodule
