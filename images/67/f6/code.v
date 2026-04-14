module top_module(
    A,
    TE,
    Z
);input A;
    input TE;
    output Z;

    // Voltage supply signals
    supply1 VPWR;
    supply0 VGND;

    assign Z = TE ? ~A : 1'b0;

endmodule