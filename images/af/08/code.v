module top_module (
    input i,
    input j,
    output k);

assign k = ~(i & j);

endmodule