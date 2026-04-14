module MatrixFactorization #(parameter N = 4, M = 4) (  
    input [N*M-1:0] user_matrix,  
    input [M*N-1:0] item_matrix,  
    output reg [N*N-1:0] predicted_ratings  
);  
    integer i, j, k;  
    always @(*) begin  
        for (i = 0; i < N; i = i + 1) begin  
            for (j = 0; j < N; j = j + 1) begin  
                predicted_ratings[i*N + j] = 0;  
                for (k = 0; k < M; k = k + 1) begin  
                    predicted_ratings[i*N + j] = predicted_ratings[i*N + j] +  
                                                   user_matrix[i*M + k] * item_matrix[k*N + j];  
                end  
            end  
        end  
    end  
endmodule