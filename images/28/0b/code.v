module IFFT (
    input wire clk,
    input wire rst,
    input wire [7:0] xr0, xi0,  // Input 0: Real, Imaginary
    input wire [7:0] xr1, xi1,  // Input 1: Real, Imaginary
    input wire [7:0] xr2, xi2,  // Input 2: Real, Imaginary
    input wire [7:0] xr3, xi3,  // Input 3: Real, Imaginary
    output reg [7:0] yr0, yi0,  // Output 0: Real, Imaginary
    output reg [7:0] yr1, yi1,  // Output 1: Real, Imaginary
    output reg [7:0] yr2, yi2,  // Output 2: Real, Imaginary
    output reg [7:0] yr3, yi3   // Output 3: Real, Imaginary
);

reg [15:0] temp_real [0:3];
reg [15:0] temp_imag [0:3];

always @(posedge clk or posedge rst) begin
    if (rst) begin
        yr0 <= 0; yi0 <= 0;
        yr1 <= 0; yi1 <= 0;
        yr2 <= 0; yi2 <= 0;
        yr3 <= 0; yi3 <= 0;
    end else begin
        // Step 1: Compute the first stage of the butterfly
        temp_real[0] = xr0 + xr1;
        temp_imag[0] = xi0 + xi1;
        temp_real[1] = xr0 - xr1;
        temp_imag[1] = xi0 - xi1;

        temp_real[2] = xr2 + xr3;
        temp_imag[2] = xi2 + xi3;
        temp_real[3] = xr2 - xr3;
        temp_imag[3] = xi2 - xi3;

        // Step 2: Compute the second stage of the butterfly
        yr0 <= (temp_real[0] + temp_real[2]) >> 2;
        yi0 <= (temp_imag[0] + temp_imag[2]) >> 2;
        yr1 <= (temp_real[1] + temp_real[3]) >> 2;
        yi1 <= (temp_imag[1] + temp_imag[3]) >> 2;
        yr2 <= (temp_real[0] - temp_real[2]) >> 2;
        yi2 <= (temp_imag[0] - temp_imag[2]) >> 2;
        yr3 <= (temp_real[1] - temp_real[3]) >> 2;
        yi3 <= (temp_imag[1] - temp_imag[3]) >> 2;
    end
end

endmodule