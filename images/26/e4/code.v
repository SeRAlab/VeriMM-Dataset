module fir_filter (
    input [7:0] x0, x1, x2, x3, // input samples
    output [15:0] y // output result
);
    parameter C0 = 8'd1; // Coefficient for x0
    parameter C1 = 8'd2; // Coefficient for x1
    parameter C2 = 8'd3; // Coefficient for x2
    parameter C3 = 8'd4; // Coefficient for x3

    assign y = (C0 * x0) + (C1 * x1) + (C2 * x2) + (C3 * x3);
endmodule