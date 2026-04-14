module top_module(
    X,
    A1,
    A2,
    B1
);// Module ports
    output X;
    input A1;
    input A2;
    input B1;

    // Module supplies
    supply1 VPWR;
    supply0 VGND;

    // Local signals
    wire and_out;
    wire inv_out;

    // AND gate
    and and1 (and_out, A1, A2, B1);

    // Inverter
    not inv1 (inv_out, and_out);

    // Buffer
    buf buf1 (X, inv_out);

endmodule