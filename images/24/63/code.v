module fir_filter (
    input [3:0] x,           // 4-bit input signal
    output reg [7:0] y       // 8-bit output signal (to accommodate the sum)
);
    // Coefficients of the FIR filter
    parameter COEFF0 = 1;
    parameter COEFF1 = 2;
    parameter COEFF2 = 3;
    parameter COEFF3 = 4;

    always @(*) begin
        // Output calculation
        y = (x * COEFF0) + (x * COEFF1) + (x * COEFF2) + (x * COEFF3);
    end
endmodule