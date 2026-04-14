module top_module (
    input u,
    input v,
    output w);

assign w = ~(u | v);

endmodule