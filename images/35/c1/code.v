module mux2to1 (
    input [3:0] a,      // First input
    input [3:0] b,      // Second input
    input sel,          // Select signal
    output [3:0] out    // Output
);
    assign out = sel ? b : a; // If sel is 1, output b, else output a
endmodule