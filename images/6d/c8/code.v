module top_module (
    input c,
    input d,
    output e);

assign e = ~(c & d);

endmodule