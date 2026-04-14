module top_module (
    input [2:0] a,
    output reg [15:0] q
);  always @(*)
    case (a)
      0: q = 16'hebf9;
      1: q = 16'hd40d;
      2: q = 16'hbbe7;
      3: q = 16'hda6f;
      4: q = 16'hb57e;
      5: q = 16'h9174;
      6: q = 16'h2a34;
      7: q = 16'hce6c;
    endcase

endmodule
