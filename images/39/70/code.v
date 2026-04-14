module bellman_ford #(parameter N = 4) (  
    input [N*N-1:0] adj_matrix,  // Adjacency matrix
    input [2:0] source,           // Source vertex
    output reg [N-1:0] dist       // Shortest distances
);  
    integer i, j, k;  
    reg [N-1:0] temp_dist;  
  
    always @* begin  
        // Initialize distances to a large number  
        dist = {N{1'b1}}; // Set all distances to 1 (infinity)  
        dist[source] = 0; // Distance to source is 0  
  
        // Bellman-Ford relaxation process  
        for (k = 0; k < N-1; k = k + 1) begin  
            for (i = 0; i < N; i = i + 1) begin  
                for (j = 0; j < N; j = j + 1) begin  
                    if (adj_matrix[i*N+j] > 0 && dist[i] + adj_matrix[i*N+j] < dist[j]) begin  
                        dist[j] = dist[i] + adj_matrix[i*N+j];  
                    end  
                end  
            end  
        end  
    end  
endmodule