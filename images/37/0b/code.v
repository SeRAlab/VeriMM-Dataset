module jpeg_compression (
    input clk,
    input rst,
    input [63:0] pixel_values,
    output reg [63:0] compressed_values
);
    reg [7:0] quantization_matrix [0:7][0:7];

    initial begin
        // Define a simple quantization matrix
        quantization_matrix[0][0] = 16; quantization_matrix[0][1] = 11; quantization_matrix[0][2] = 10; quantization_matrix[0][3] = 16; quantization_matrix[0][4] = 24; quantization_matrix[0][5] = 40; quantization_matrix[0][6] = 51; quantization_matrix[0][7] = 61;
        quantization_matrix[1][0] = 12; quantization_matrix[1][1] = 12; quantization_matrix[1][2] = 14; quantization_matrix[1][3] = 19; quantization_matrix[1][4] = 26; quantization_matrix[1][5] = 58; quantization_matrix[1][6] = 60; quantization_matrix[1][7] = 55;
        quantization_matrix[2][0] = 14; quantization_matrix[2][1] = 13; quantization_matrix[2][2] = 16; quantization_matrix[2][3] = 24; quantization_matrix[2][4] = 40; quantization_matrix[2][5] = 57; quantization_matrix[2][6] = 69; quantization_matrix[2][7] = 56;
        quantization_matrix[3][0] = 14; quantization_matrix[3][1] = 17; quantization_matrix[3][2] = 22; quantization_matrix[3][3] = 29; quantization_matrix[3][4] = 51; quantization_matrix[3][5] = 87; quantization_matrix[3][6] = 80; quantization_matrix[3][7] = 62;
        quantization_matrix[4][0] = 18; quantization_matrix[4][1] = 22; quantization_matrix[4][2] = 37; quantization_matrix[4][3] = 61; quantization_matrix[4][4] = 60; quantization_matrix[4][5] = 80; quantization_matrix[4][6] = 109; quantization_matrix[4][7] = 100;
        quantization_matrix[5][0] = 24; quantization_matrix[5][1] = 35; quantization_matrix[5][2] = 55; quantization_matrix[5][3] = 64; quantization_matrix[5][4] = 81; quantization_matrix[5][5] = 104; quantization_matrix[5][6] = 113; quantization_matrix[5][7] = 112;
        quantization_matrix[6][0] = 49; quantization_matrix[6][1] = 64; quantization_matrix[6][2] = 78; quantization_matrix[6][3] = 87; quantization_matrix[6][4] = 103; quantization_matrix[6][5] = 126; quantization_matrix[6][6] = 104; quantization_matrix[6][7] = 113;
        quantization_matrix[7][0] = 72; quantization_matrix[7][1] = 92; quantization_matrix[7][2] = 95; quantization_matrix[7][3] = 98; quantization_matrix[7][4] = 112; quantization_matrix[7][5] = 100; quantization_matrix[7][6] = 120; quantization_matrix[7][7] = 130;
    end

    integer i, j;
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            compressed_values <= 0;
        end else begin
            for (i = 0; i < 8; i = i + 1) begin
                for (j = 0; j < 8; j = j + 1) begin
                    compressed_values[(i*8+j)*8 +: 8] <= (pixel_values[(i*8+j)*8 +: 8] + (quantization_matrix[i][j] >> 1)) / quantization_matrix[i][j];
                end
            end
        end
    end
endmodule