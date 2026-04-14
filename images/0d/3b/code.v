module fir_filter (
    input [3:0] x,  // 4-bit input signal
    output reg [5:0] y // 6-bit output signal to accommodate the maximum possible value
);
    reg [3:0] delay [0:3]; // 4-tap delay line

    always @(*) begin
        // Shift the delay line
        delay[0] = x; 
        delay[1] = delay[0];
        delay[2] = delay[1];
        delay[3] = delay[2];

        // Compute the output as the sum of products
        y = (1 * delay[0]) + (2 * delay[1]) + (3 * delay[2]) + (4 * delay[3]);
    end
endmodule