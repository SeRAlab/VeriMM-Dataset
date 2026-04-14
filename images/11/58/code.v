module FloydWarshall #(parameter N = 4) (  
    input [N*N-1:0] adjacency_matrix,  
    output reg [N*N-1:0] distance_matrix  
);  
    integer i, j, k;  
    reg [N*N-1:0] temp_distance;  
    always @(*) begin  
        // Initialize distance matrix  
        distance_matrix = adjacency_matrix;  
        // Floyd-Warshall algorithm  
        for (k = 0; k < N; k = k + 1) begin  
            for (i = 0; i < N; i = i + 1) begin  
                for (j = 0; j < N; j = j + 1) begin  
                    if (distance_matrix[i*N + k] + distance_matrix[k*N + j] < distance_matrix[i*N + j]) begin  
                        distance_matrix[i*N + j] = distance_matrix[i*N + k] + distance_matrix[k*N + j];  
                    end  
                end  
            end  
        end  
    end  
endmodule