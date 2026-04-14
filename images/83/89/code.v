module top_module (
    input f,
    output u);

assign u = ~(f | 0);

endmodule