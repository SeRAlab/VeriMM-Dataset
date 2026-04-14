module top_module(
    input [3:0] signal_a,
    input [2:0] signal_b,
    input [1:0] signal_c,
    input signal_d,
    output signal_out
);wire [6:0] signal_ab;
    wire [2:0] signal_cd;
    
    assign signal_ab = {signal_a, signal_b};
    assign signal_cd = {signal_c, signal_d};
    
    assign signal_out = ^signal_ab ^ signal_cd;
    
endmodule