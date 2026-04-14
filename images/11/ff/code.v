module matrix_factorization #(parameter USER_DIM=4, ITEM_DIM=4, FACTOR_DIM=2)  
(  
    input clk,  
    input rst,  
    input [USER_DIM*ITEM_DIM-1:0] interaction_matrix,  
    output reg [USER_DIM*FACTOR_DIM-1:0] user_factors,  
    output reg [ITEM_DIM*FACTOR_DIM-1:0] item_factors,  
    output reg done  
);  

    reg [FACTOR_DIM-1:0] user_latent [0:USER_DIM-1];  
    reg [FACTOR_DIM-1:0] item_latent [0:ITEM_DIM-1];  

    integer i, j, k;  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            done <= 0;  
            for (i = 0; i < USER_DIM; i = i + 1)  
                user_latent[i] <= 0;  
            for (j = 0; j < ITEM_DIM; j = j + 1)  
                item_latent[j] <= 0;  
        end else begin  
            // Perform ALS iterations here (simple example)  
            for (i = 0; i < USER_DIM; i = i + 1) begin  
                for (j = 0; j < ITEM_DIM; j = j + 1) begin  
                    if (interaction_matrix[i * ITEM_DIM + j]) begin  
                        for (k = 0; k < FACTOR_DIM; k = k + 1) begin  
                            user_latent[i][k] <= user_latent[i][k] + interaction_matrix[i * ITEM_DIM + j] * item_latent[j][k];  
                            item_latent[j][k] <= item_latent[j][k] + interaction_matrix[i * ITEM_DIM + j] * user_latent[i][k];  
                        end  
                    end  
                end  
            end  
            // Assign output  
            for (i = 0; i < USER_DIM; i = i + 1)  
                user_factors[i * FACTOR_DIM +: FACTOR_DIM] <= user_latent[i];  
            for (j = 0; j < ITEM_DIM; j = j + 1)  
                item_factors[j * FACTOR_DIM +: FACTOR_DIM] <= item_latent[j];  
            done <= 1;  
        end  
    end  
endmodule