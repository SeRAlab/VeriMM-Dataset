module one_bit_adder(
    input xi,
    input yi,
    output Si,
    output Co
);

    assign Si = xi ^ yi;
    assign Co = xi & yi;

endmodule