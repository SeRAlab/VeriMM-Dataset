module top_module (
    input [2:0] a,
    output reg [15:0] q
);  always @(*)
    case (a)
      0: q = 16'hc6be;
      1: q = 16'hce78;
      2: q = 16'h7e80;
      3: q = 16'h2df1;
      4: q = 16'hf89b;
      5: q = 16'hc70e;
      6: q = 16'he382;
      7: q = 16'ha2bd;
    endcase

endmodule
