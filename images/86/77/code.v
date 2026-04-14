module top_module(
    input [3:0] v,
    output wire z
    );assign z = (v > 9) ? 1 : 0;
    
endmodule