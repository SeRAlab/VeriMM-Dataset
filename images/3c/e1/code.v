module fir_filter (
    input [7:0] x,       // 8-bit input signal
    output reg [7:0] y   // 8-bit output signal
);

reg [7:0] coeff [0:7]; // Coefficients for the FIR filter
reg [15:0] temp;       // Temporary variable for accumulation

integer i;

initial begin
    // Example coefficients for the FIR filter
    coeff[0] = 8'h1;
    coeff[1] = 8'h2;
    coeff[2] = 8'h3;
    coeff[3] = 8'h4;
    coeff[4] = 8'h5;
    coeff[5] = 8'h6;
    coeff[6] = 8'h7;
    coeff[7] = 8'h8;
end

always @(*) begin
    temp = 0;
    // Perform the FIR filtering operation
    for (i = 0; i < 8; i = i + 1) begin
        temp = temp + (coeff[i] * x); // Here we assume x is delayed properly in a real case
    end
    y = temp[7:0]; // Assign the lower 8 bits to output
end

endmodule