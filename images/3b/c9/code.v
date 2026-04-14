module MatrixFactorization(
    input clk,
    input reset,
    input [3:0] user_idx, // Assuming a maximum of 16 users
    input [3:0] item_idx, // Assuming a maximum of 16 items
    input [7:0] rating,    // Input rating from user for item
    input valid,           // Signal to indicate valid input
    output reg [7:0] predicted_rating // Predicted rating output
);

    // Parameters for matrix factorization
    parameter NUM_USERS = 16;
    parameter NUM_ITEMS = 16;
    parameter LATENT_DIM = 4; // Number of latent features

    reg [7:0] user_factors[0:NUM_USERS-1][0:LATENT_DIM-1]; // User latent factors
    reg [7:0] item_factors[0:NUM_ITEMS-1][0:LATENT_DIM-1]; // Item latent factors

    integer i, j;

    // Initialize factors (for simplicity, using random initial values)
    initial begin
        for (i = 0; i < NUM_USERS; i = i + 1) begin
            for (j = 0; j < LATENT_DIM; j = j + 1) begin
                user_factors[i][j] = $random % 256;
            end
        end
        for (i = 0; i < NUM_ITEMS; i = i + 1) begin
            for (j = 0; j < LATENT_DIM; j = j + 1) begin
                item_factors[i][j] = $random % 256;
            end
        end
    end

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            predicted_rating <= 8'b0;
        end else if (valid) begin
            // Calculate predicted rating using dot product of user and item factors
            predicted_rating <= 8'b0;
            for (j = 0; j < LATENT_DIM; j = j + 1) begin
                predicted_rating <= predicted_rating + (user_factors[user_idx][j] * item_factors[item_idx][j]);
            end
        end
    end
endmodule