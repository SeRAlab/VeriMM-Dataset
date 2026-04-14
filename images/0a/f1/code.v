module chebyshev_filter (
    input [4:0] signal_in,
    output reg [4:0] signal_out
);
    reg [4:0] coeff [0:4]; // Coefficients for the 4th order filter
    reg [4:0] y [0:4]; // Intermediate values

    initial begin
        // Example coefficients for a Chebyshev filter
        coeff[0] = 5'd1;
        coeff[1] = 5'd4;
        coeff[2] = 5'd6;
        coeff[3] = 5'd4;
        coeff[4] = 5'd1;
    end

    always @(*) begin
        y[0] = coeff[0] * signal_in;
        y[1] = coeff[1] * signal_in + y[0];
        y[2] = coeff[2] * signal_in + y[1];
        y[3] = coeff[3] * signal_in + y[2];
        signal_out = coeff[4] * signal_in + y[3];
    end
endmodule