module mux_2to1 (
    input  wire a,
    input  wire b,
    input  wire sel,
    output wire y
);

    assign y = (sel == 0) ? a : b;

endmodule