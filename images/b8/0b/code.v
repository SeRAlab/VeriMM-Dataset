module top_module(en, en2, ld, clk_en);input       en, en2;
    input       ld;
    output      clk_en;
    
    assign clk_en = (en && en2) || (ld);

endmodule