module top_module(
    Y,
    A1,
    A2,
    B1
);// Module ports
    output Y;
    input A1;
    input A2;
    input B1;

    // Local signals
    wire and0_out;
    wire nor0_out_Y;

    // Implement AND operation
    and and0 (and0_out, A1, A2);

    // Implement NOR operation
    nor nor0 (nor0_out_Y, B1, and0_out);

    // Implement buffer
    buf buf0 (Y, nor0_out_Y);

endmodule