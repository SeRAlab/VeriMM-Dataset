module top_module (
    input [2:0] a,
    output reg [15:0] q
);  always @(*)
    case (a)
      0: q = 16'hddcd;
      1: q = 16'h6bfd;
      2: q = 16'h665c;
      3: q = 16'h30ec;
      4: q = 16'he23c;
      5: q = 16'h4a40;
      6: q = 16'h53fc;
      7: q = 16'h109e;
    endcase

endmodule
