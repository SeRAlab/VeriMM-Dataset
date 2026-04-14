module top_module (
    input k,
    input l,
    output v);

assign v = ~(k ^ l);

endmodule