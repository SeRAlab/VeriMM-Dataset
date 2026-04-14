module fir_filter(
    input [15:0] x0, x1, x2, x3, x4, x5, x6, x7, // 8 input samples
    output reg [31:0] y // output sample
);
    // Define the FIR filter coefficients (example coefficients)
    parameter [15:0] coeff0 = 16'h0001;
    parameter [15:0] coeff1 = 16'h0002;
    parameter [15:0] coeff2 = 16'h0003;
    parameter [15:0] coeff3 = 16'h0004;
    parameter [15:0] coeff4 = 16'h0005;
    parameter [15:0] coeff5 = 16'h0006;
    parameter [15:0] coeff6 = 16'h0007;
    parameter [15:0] coeff7 = 16'h0008;

    always @(*) begin
        y = (x0 * coeff0) + (x1 * coeff1) + (x2 * coeff2) + (x3 * coeff3) +
            (x4 * coeff4) + (x5 * coeff5) + (x6 * coeff6) + (x7 * coeff7);
    end
endmodule