module top_module(input ALUT, BLUT, C0, output Z);assign Z = C0 ? ALUT : BLUT;
endmodule