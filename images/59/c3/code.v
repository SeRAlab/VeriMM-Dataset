module top_module (
    input [2:0] a,
    output reg [15:0] q
);  always @(*)
    case (a)
      0: q = 16'h7098;
      1: q = 16'hedaa;
      2: q = 16'h0f1e;
      3: q = 16'hf450;
      4: q = 16'ha8ae;
      5: q = 16'h8735;
      6: q = 16'h1f8d;
      7: q = 16'h9037;
    endcase

endmodule
