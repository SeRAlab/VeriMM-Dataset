module top_module (
    input [2:0] a,
    output reg [15:0] q
);  always @(*)
    case (a)
      0: q = 16'h9e61;
      1: q = 16'hae95;
      2: q = 16'habb2;
      3: q = 16'h0675;
      4: q = 16'h3389;
      5: q = 16'hf0ea;
      6: q = 16'hda00;
      7: q = 16'ha0fd;
    endcase

endmodule
