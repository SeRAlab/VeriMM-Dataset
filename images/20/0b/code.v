module matrix_factorization #(parameter N = 4, M = 4, K = 2, ITERATIONS = 10) (
    input clk,
    input reset,
    input [N*M*8-1:0] input_matrix, // input matrix flattened
    input [7:0] learning_rate,
    output reg [N*K*8-1:0] user_matrix, // user matrix flattened
    output reg [K*M*8-1:0] item_matrix // item matrix flattened
);

    reg [N*K*8-1:0] user_matrix_next;
    reg [K*M*8-1:0] item_matrix_next;
    integer i, j, k;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            user_matrix <= 0;
            item_matrix <= 0;
        end else begin
            // Perform matrix factorization update
            for (i = 0; i < N; i = i + 1) begin
                for (j = 0; j < M; j = j + 1) begin
                    if (input_matrix[i*M + j] != 0) begin // Only update for non-zero entries
                        for (k = 0; k < K; k = k + 1) begin
                            user_matrix_next[i*K + k] = user_matrix[i*K + k] + 
                                learning_rate * (input_matrix[i*M + j] - (user_matrix[i*K + k] * item_matrix[k*M + j]));
                            item_matrix_next[k*M + j] = item_matrix[k*M + j] + 
                                learning_rate * (input_matrix[i*M + j] - (user_matrix[i*K + k] * item_matrix[k*M + j]));
                        end
                    end
                end
            end
            user_matrix <= user_matrix_next;
            item_matrix <= item_matrix_next;
        end
    end
endmodule