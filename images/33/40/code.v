module fir_filter (
    input wire [3:0] x,            // 4-bit input signal
    output wire [3:0] y            // 4-bit output signal
);
    // FIR filter coefficients
    reg [3:0] h [0:3];             // 4 coefficients for 4-tap FIR filter
    initial begin
        h[0] = 4'b0001;            // Coefficient 1
        h[1] = 4'b0010;            // Coefficient 2
        h[2] = 4'b0100;            // Coefficient 3
        h[3] = 4'b1000;            // Coefficient 4
    end

    wire [7:0] product [0:3];      // Intermediate products (8-bit to avoid overflow)
    assign product[0] = x * h[0];
    assign product[1] = x * h[1];
    assign product[2] = x * h[2];
    assign product[3] = x * h[3];

    // Sum the products
    wire [7:0] sum;
    assign sum = product[0] + product[1] + product[2] + product[3];

    // Output the lower 4 bits of the sum
    assign y = sum[3:0];
endmodule