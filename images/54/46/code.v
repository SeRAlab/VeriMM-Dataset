module top_module (
    input [2:0] a,
    output reg [15:0] q
);  always @(*)
    case (a)
      0: q = 16'h8241;
      1: q = 16'hf4d6;
      2: q = 16'h8020;
      3: q = 16'hd288;
      4: q = 16'h3556;
      5: q = 16'he352;
      6: q = 16'h60ca;
      7: q = 16'hb805;
    endcase

endmodule
