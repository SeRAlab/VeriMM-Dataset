module top_module(
    X0,
    X1,
    X2,
    X3,
    A0,
    A1,
    S
);output X0;
    output X1;
    output X2;
    output X3;
    input A0;
    input A1;
    input S;

    // Voltage supply signals
    supply1 VPWR;
    supply0 VGND;
    supply1 VPB;
    supply0 VNB;

    wire w1, w2;

    // Assuming the correct mux implementation
    assign w1 = (S) ? A1 : A0; // First multiplexer logic
    assign w2 = (S) ? A0 : A1; // Second multiplexer logic

    assign X0 = (S) ? w1 : w1; // Logic for X0
    assign X1 = (S) ? w2 : w2; // Logic for X1
    assign X2 = (S) ? w1 : w2; // Logic for X2
    assign X3 = (~S) ? w1 : w2; // Logic for X3

endmodule