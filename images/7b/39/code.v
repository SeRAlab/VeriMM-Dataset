module top_module (
    input s,
    input t,
    output u);

assign u = ~(s & t);

endmodule