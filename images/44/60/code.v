module top_module(
    output X,
    input  A0,
    input  A1,
    input  S,
    input  VPWR,
    input  VGND
);wire X0, notS;

    assign notS = ~S; // Creating the complement of the select signal S

    // Using basic gates for the MUX implementation instead of the unknown module
    assign X0 = (A0 & notS) | (A1 & S); // MUX logic

    assign X = X0;

endmodule