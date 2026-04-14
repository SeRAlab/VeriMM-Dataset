module top_module(
    // module ports
    output Y,
    input A1,
    input A2,
    input B1,
    input B2,
    input C1
);// internal signals
    wire and0_out;
    wire and1_out;
    wire nor0_out_Y;
    wire buf0_out;

    // AND gates
    and and0 (and0_out, B1, B2);
    and and1 (and1_out, A1, A2);

    // NOR gate
    nor nor0 (nor0_out_Y, and0_out, C1, and1_out);

    // buffer
    buf buf0 (Y, nor0_out_Y);

endmodule