module mux_2to1_forward (
    input wire [7:0] a,      // First input
    input wire [7:0] b,      // Second input
    input wire sel,          // Select line
    input wire forward_en,   // Forward enable line
    output wire [7:0] y      // Output
);
    assign y = forward_en ? b : (sel ? b : a);
endmodule