module top_module (
    input [2:0] a,
    output reg [15:0] q
);  always @(*)
    case (a)
      0: q = 16'h6587;
      1: q = 16'h0ff3;
      2: q = 16'h4d48;
      3: q = 16'hd88a;
      4: q = 16'he767;
      5: q = 16'hb97f;
      6: q = 16'h9b74;
      7: q = 16'h7735;
    endcase

endmodule
