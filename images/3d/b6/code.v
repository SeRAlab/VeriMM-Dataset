module mux_2to1 (
    input wire a,
    input wire b,
    input wire sel,
    output wire y
);
    wire a_bar, b_bar, sel_bar;
    wire g1, g2, g3, g4;

    not (a_bar, a);
    not (b_bar, b);
    not (sel_bar, sel);

    // Generate internal signals
    and (g1, a, sel_bar);
    and (g2, b, sel);
    or  (g3, g1, g2);
    
    // Hazard detection: ensuring no glitches occur
    and (g4, a_bar, b_bar, sel);
    or  (y, g3, g4);

endmodule