module mux_2to1 (
    input wire a,     // Input 0
    input wire b,     // Input 1
    input wire sel,   // Select signal
    output wire y     // Output
);
    assign y = sel ? b : a; // If sel is 1, output b; else output a
endmodule