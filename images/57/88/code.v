module top_module(input shortint signed a, b, output shortint signed sc, ss);assign sc = a + b;
   always @(a, b) ss = a + b;
endmodule