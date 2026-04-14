module fir_filter (
    input wire [3:0] x, // 4-bit input
    output wire [3:0] y // 4-bit output
);
    // Filter coefficients
    parameter [3:0] h0 = 4'd1;
    parameter [3:0] h1 = 4'd2;
    parameter [3:0] h2 = 4'd2;
    parameter [3:0] h3 = 4'd1;

    // FIR filter calculation
    assign y = (h0 * x) + (h1 * {x[3:1], 1'b0}) + (h2 * {x[3:2], 2'b0}) + (h3 * {x[3], 3'b0});
endmodule