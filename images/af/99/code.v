module top_module (
    input [2:0] a,
    output reg [15:0] q
);  always @(*)
    case (a)
      0: q = 16'heea5;
      1: q = 16'h261d;
      2: q = 16'hce44;
      3: q = 16'hba98;
      4: q = 16'h93ed;
      5: q = 16'h083d;
      6: q = 16'hf5d3;
      7: q = 16'hc17b;
    endcase

endmodule
