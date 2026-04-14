module top_module (
    input g,
    output t);

assign t = ~(g ^ 1);

endmodule