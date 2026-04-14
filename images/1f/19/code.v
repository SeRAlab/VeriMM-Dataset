module fir_filter (
    input [7:0] x,
    output reg [7:0] y
);
    reg [7:0] coeff[0:7]; // Coefficients of the FIR filter
    reg [15:0] sum;       // To hold the sum of products

    integer i;

    initial begin
        // Example coefficients (can be modified)
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
        sum = 16'h0; // Reset sum
        for (i = 0; i < 8; i = i + 1) begin
            sum = sum + (x * coeff[i]); // Multiply and sum
        end
        y = sum[7:0]; // Take the lower 8 bits of the sum
    end
endmodule