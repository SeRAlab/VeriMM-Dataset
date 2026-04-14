module top_module(
    input u,
    input v,
    input w,
    input s0,
    input s1,
    output m
    );wire tra;
    
    // Implementing (~s0 & u) | (s0 & v)
    assign tra = (~s0 & u) | (s0 & v);
    
    // Implementing (~s1 & tra) | (s1 & w)
    assign m = (~s1 & tra) | (s1 & w);
    
endmodule