module matrix_factorization(
    input clk,
    input enable,
    input [8*9-1:0] ratings, // 3x3 matrix
    output reg [8*3-1:0] user_features, // 3x3 matrix
    output reg [8*3-1:0] item_features // 3x3 matrix
);
    reg [8*3-1:0] U [0:2]; // User features
    reg [8*3-1:0] V [0:2]; // Item features

    integer i, j, k;
    initial begin
        // Initialize U and V with some values for demonstration
        for(i = 0; i < 3; i = i + 1) begin
            U[i] = 8'h10; // Example initialization
            V[i] = 8'h20; // Example initialization
        end
    end

    always @(posedge clk) begin
        if (enable) begin
            // Simple matrix factorization logic (for demonstration)
            for(i = 0; i < 3; i = i + 1) begin
                for(j = 0; j < 3; j = j + 1) begin
                    if (ratings[i*3+j] != 0) begin
                        for(k = 0; k < 3; k = k + 1) begin
                            U[i][k*8 +: 8] = U[i][k*8 +: 8] + (ratings[i*3+j] - U[i] * V[j][k]) * V[j][k]; // Update user features
                            V[j][k*8 +: 8] = V[j][k*8 +: 8] + (ratings[i*3+j] - U[i] * V[j][k]) * U[i][k]; // Update item features
                        end
                    end
                end
            end
            user_features = {U[0], U[1], U[2]};
            item_features = {V[0], V[1], V[2]};
        end
    end
endmodule