module fir_filter (
    input [7:0] x, // 8-bit input
    output reg [7:0] y // 8-bit output
);
    reg [7:0] coeffs [0:7]; // FIR filter coefficients
    reg [15:0] product [0:7]; // products of coefficients and inputs
    integer i;

    initial begin
        // Initialize coefficients (example coefficients)
        coeffs[0] = 8'b00000001;
        coeffs[1] = 8'b00000010;
        coeffs[2] = 8'b00000011;
        coeffs[3] = 8'b00000100;
        coeffs[4] = 8'b00000101;
        coeffs[5] = 8'b00000110;
        coeffs[6] = 8'b00000111;
        coeffs[7] = 8'b00001000;
    end

    always @(*) begin
        // Compute the output
        y = 8'b0; // Reset output
        for (i = 0; i < 8; i = i + 1) begin
            product[i] = x * coeffs[i]; // Multiply input by coefficients
            y = y + product[i][7:0]; // Sum the products (take lower 8 bits)
        end
    end
endmodule