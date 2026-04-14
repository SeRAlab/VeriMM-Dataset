module mux2to1 (
    input wire a,        // Input signal A
    input wire b,        // Input signal B
    input wire sel,      // Select line
    output wire y        // Output signal
);
    assign y = (sel) ? b : a;  // Multiplexer logic
endmodule