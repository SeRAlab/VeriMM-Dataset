module top_module(
    input A, B, C, D, SEL0, SEL1,
    output Y);assign Y = SEL0 & SEL1 ? D : SEL0 ? C : SEL1 ? B : A;
    
endmodule