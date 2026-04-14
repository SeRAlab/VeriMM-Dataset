module top_module (
    input [2:0] a,
    output reg [15:0] q
);  always @(*)
    case (a)
      0: q = 16'h4dd7;
      1: q = 16'h9c76;
      2: q = 16'h0631;
      3: q = 16'h6a08;
      4: q = 16'h44e1;
      5: q = 16'h793f;
      6: q = 16'h58ce;
      7: q = 16'h98b5;
    endcase

endmodule
