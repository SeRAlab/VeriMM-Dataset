module fir_filter (
    input [3:0] x0, // current input
    input [3:0] x1, // previous input
    input [3:0] x2, // two samples ago
    input [3:0] x3, // three samples ago
    output [4:0] y   // output (5 bits to accommodate possible overflow)
);
    // Coefficients
    parameter C0 = 1;
    parameter C1 = 2;
    parameter C2 = 1;
    parameter C3 = 0;

    assign y = (C0 * x0) + (C1 * x1) + (C2 * x2) + (C3 * x3);
endmodule