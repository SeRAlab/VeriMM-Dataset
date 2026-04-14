module top_module (
    input u,
    input v,
    output t);

assign t = ~(u ^ v);

endmodule