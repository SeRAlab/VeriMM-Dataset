module top_module(
    input A, B, SEL,
    output Y);assign Y = SEL ? B : A;
    
endmodule