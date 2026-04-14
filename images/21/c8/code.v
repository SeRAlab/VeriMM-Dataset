module jpeg_dct (
    input wire [63:0] pixel_values, // 8x8 block of pixels flattened
    output reg [63:0] dct_coefficients // DCT coefficients output
);
    integer i, j;
    reg [7:0] coeff[0:7][0:7]; // Coefficient array
    reg [15:0] sum; // Temporary variable for sum

    initial begin
        // Initialize the coefficients
        coeff[0][0] = 1; coeff[0][1] = 1; coeff[0][2] = 1; coeff[0][3] = 1; coeff[0][4] = 1; coeff[0][5] = 1; coeff[0][6] = 1; coeff[0][7] = 1;
        coeff[1][0] = 1; coeff[1][1] = 0; coeff[1][2] = -1; coeff[1][3] = 0; coeff[1][4] = 1; coeff[1][5] = 0; coeff[1][6] = -1; coeff[1][7] = 0;
        coeff[2][0] = 1; coeff[2][1] = -1; coeff[2][2] = 0; coeff[2][3] = 0; coeff[2][4] = 1; coeff[2][5] = -1; coeff[2][6] = 0; coeff[2][7] = 0;
        coeff[3][0] = 1; coeff[3][1] = 0; coeff[3][2] = 0; coeff[3][3] = -1; coeff[3][4] = 1; coeff[3][5] = 0; coeff[3][6] = 0; coeff[3][7] = -1;
        coeff[4][0] = 1; coeff[4][1] = 1; coeff[4][2] = 1; coeff[4][3] = 1; coeff[4][4] = -1; coeff[4][5] = -1; coeff[4][6] = -1; coeff[4][7] = -1;
        coeff[5][0] = 1; coeff[5][1] = -1; coeff[5][2] = -1; coeff[5][3] = 1; coeff[5][4] = 1; coeff[5][5] = -1; coeff[5][6] = -1; coeff[5][7] = 1;
        coeff[6][0] = 1; coeff[6][1] = 0; coeff[6][2] = 0; coeff[6][3] = 0; coeff[6][4] = 1; coeff[6][5] = 0; coeff[6][6] = 0; coeff[6][7] = 0;
        coeff[7][0] = 1; coeff[7][1] = -1; coeff[7][2] = 1; coeff[7][3] = -1; coeff[7][4] = 1; coeff[7][5] = -1; coeff[7][6] = 1; coeff[7][7] = -1;
    end

    always @(*) begin
        // Compute DCT coefficients
        for (i = 0; i < 8; i = i + 1) begin
            sum = 0;
            for (j = 0; j < 8; j = j + 1) begin
                sum = sum + (pixel_values[j + (i * 8)] * coeff[i][j]);
            end
            dct_coefficients[i] = sum;
        end
    end
endmodule