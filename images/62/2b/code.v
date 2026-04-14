module top_module(
    input sel,
    input in1,
    input in2,
    output out
);wire n_sel;
    assign n_sel = ~sel;
    
    assign out = (n_sel & in1) | (sel & 1'b1);
    
endmodule