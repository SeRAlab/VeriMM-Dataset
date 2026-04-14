module fir_filter (
    input wire signed [4:0] x,         // Current input
    input wire signed [4:0] x1,        // Previous input
    input wire signed [4:0] x2,        // Input before previous
    output wire signed [4:0] y          // Output
);
    assign y = (x * 1) + (x1 * 2) + (x2 * 1);
endmodule