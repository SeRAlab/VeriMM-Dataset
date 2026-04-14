module fir_filter (
    input wire [15:0] x0, // Current input sample
    input wire [15:0] x1, // Previous input sample
    input wire [15:0] x2, // Two samples ago
    input wire [15:0] x3, // Three samples ago
    output wire [31:0] y   // Output sample
);
    assign y = (1 * x0) + (2 * x1) + (3 * x2) + (4 * x3);
endmodule