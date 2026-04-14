module matrix_factorization (
    input [63:0] input_matrix, // 8x8 matrix as a flattened array (8 rows, 8 columns)
    output reg [31:0] user_matrix, // 8x4 user-feature matrix
    output reg [31:0] item_matrix  // 4x8 item-feature matrix
);
    integer i, j;
    reg [7:0] matrix [0:7][0:7]; // 2D array for the input matrix
    reg [7:0] user_temp [0:7][0:3]; // 2D array for the user matrix
    reg [7:0] item_temp [0:3][0:7]; // 2D array for the item matrix

    initial begin
        // Unpack the input_matrix to the 2D array
        for (i = 0; i < 8; i = i + 1) begin
            for (j = 0; j < 8; j = j + 1) begin
                matrix[i][j] = input_matrix[(i * 8 + j) * 8 +: 8];
            end
        end

        // Simple averaging for user features (0-3)
        for (i = 0; i < 8; i = i + 1) begin
            for (j = 0; j < 4; j = j + 1) begin
                user_temp[i][j] = (matrix[i][j*2] + matrix[i][j*2+1]) / 2; // Average of two columns
            end
        end

        // Simple averaging for item features (0-3)
        for (j = 0; j < 8; j = j + 1) begin
            for (i = 0; i < 4; i = i + 1) begin
                item_temp[i][j] = (matrix[i*2][j] + matrix[i*2+1][j]) / 2; // Average of two rows
            end
        end

        // Pack the output matrices into the output registers
        for (i = 0; i < 8; i = i + 1) begin
            for (j = 0; j < 4; j = j + 1) begin
                user_matrix[(i * 4 + j) * 8 +: 8] = user_temp[i][j];
            end
        end
        
        for (i = 0; i < 4; i = i + 1) begin
            for (j = 0; j < 8; j = j + 1) begin
                item_matrix[(i * 8 + j) * 8 +: 8] = item_temp[i][j];
            end
        end
    end
endmodule