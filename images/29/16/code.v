module fir_filter (
    input [7:0] x_in,
    output reg [15:0] y_out
);
    reg [7:0] coeff[0:7]; // Coefficients for the FIR filter
    reg [15:0] product[0:7]; // Intermediate products
    integer i;

    initial begin
        // Initialize coefficients (example coefficients)
        coeff[0] = 8'd1;
        coeff[1] = 8'd2;
        coeff[2] = 8'd3;
        coeff[3] = 8'd4;
        coeff[4] = 8'd5;
        coeff[5] = 8'd6;
        coeff[6] = 8'd7;
        coeff[7] = 8'd8;
    end

    always @(*) begin
        y_out = 16'd0; // Reset output
        for (i = 0; i < 8; i = i + 1) begin
            product[i] = x_in * coeff[i]; // Multiply input with each coefficient
            y_out = y_out + product[i]; // Accumulate the results
        end
    end
endmodule