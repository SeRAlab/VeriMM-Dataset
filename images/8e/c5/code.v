module top_module(
    input a,
    input b,
    input sel_b1,
    input sel_b2,
    output reg out_always
);wire sel = sel_b1 & sel_b2;
    wire not_sel = ~sel;
    
    assign out_always = (sel & b) | (not_sel & a);
    
endmodule