module top_module(
    input xi,
    input yi,
    output Si,
    output Co
);assign Si = xi ^ yi;
    assign Co = xi & yi;

endmodule