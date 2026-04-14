module mux2to1 (
    input wire a,      // Input a
    input wire b,      // Input b
    input wire sel,    // Select signal
    output wire y      // Output
);
    assign y = (sel) ? b : a; // If sel is 1, output b; otherwise output a
endmodule