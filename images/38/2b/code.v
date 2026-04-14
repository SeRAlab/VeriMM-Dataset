module fir_filter (
    input [4:0] x,       // 5-bit input
    output reg [4:0] y   // 5-bit output
);

reg [4:0] samples [0:4]; // Array to hold the last 5 samples

integer i;

always @(*) begin
    // Shift samples
    for (i = 4; i > 0; i = i - 1) begin
        samples[i] = samples[i - 1];
    end
    samples[0] = x; // New sample at the front

    // Compute output using fixed coefficients
    y = (1 * samples[0]) + (2 * samples[1]) + (3 * samples[2]) + (2 * samples[3]) + (1 * samples[4]);
end
endmodule