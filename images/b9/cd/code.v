module top_module (
    input [2:0] a,
    output reg [15:0] q
);  always @(*)
    case (a)
      0: q = 16'h50b6;
      1: q = 16'hff52;
      2: q = 16'h58ea;
      3: q = 16'h84c4;
      4: q = 16'h58e5;
      5: q = 16'h8777;
      6: q = 16'haa47;
      7: q = 16'ha009;
    endcase

endmodule
