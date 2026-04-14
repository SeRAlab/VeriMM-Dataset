module top_module(input SEL, a, b, output f);assign sel_n = ~ SEL;

  assign f = (a & sel_n) | (b & SEL);

endmodule