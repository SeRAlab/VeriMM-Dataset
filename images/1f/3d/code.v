module mux_2_to_1 (
    input wire a,      // First input
    input wire b,      // Second input
    input wire sel,    // Select line
    output wire y      // Output
);
    assign y = (sel) ? b : a; // If sel is 1, output b; otherwise output a
endmodule