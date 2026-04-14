module top_module (
    input [2:0] a,
    output reg [15:0] q
);  always @(*)
    case (a)
      0: q = 16'h569f;
      1: q = 16'hd08c;
      2: q = 16'h052c;
      3: q = 16'h253a;
      4: q = 16'h8259;
      5: q = 16'h3c0d;
      6: q = 16'h7441;
      7: q = 16'hd9ea;
    endcase

endmodule
