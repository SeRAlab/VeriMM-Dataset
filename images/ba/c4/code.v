module top_module (
    input [2:0] a,
    output reg [15:0] q
);  always @(*)
    case (a)
      0: q = 16'h1b83;
      1: q = 16'h9282;
      2: q = 16'h79af;
      3: q = 16'h0e28;
      4: q = 16'h8c93;
      5: q = 16'h3018;
      6: q = 16'hb9e3;
      7: q = 16'h6637;
    endcase

endmodule
