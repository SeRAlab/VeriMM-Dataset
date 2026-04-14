module top_module (
    input n,
    input o,
    output p);

assign p = ~(n & o);

endmodule