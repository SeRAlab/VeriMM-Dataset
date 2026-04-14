module bellman_ford #(parameter N = 5) (  
    input [N*N-1:0] adj_matrix, // Adjacency matrix for the graph  
    input [N-1:0] src,           // Source vertex  
    output reg [N-1:0] dist      // Shortest distance from source vertex  
);  
    integer i, j, k;  
    reg [N-1:0] temp_dist;  
    reg [N-1:0] current_dist [0:N-1];  
  
    always @(*) begin  
        // Initialize distances  
        for (i = 0; i < N; i = i + 1) begin  
            if (i == src)  
                current_dist[i] = 0;  
            else  
                current_dist[i] = 8'hFF; // Infinity  
        end  
  
        // Relax edges N-1 times  
        for (k = 0; k < N-1; k = k + 1) begin  
            for (i = 0; i < N; i = i + 1) begin  
                for (j = 0; j < N; j = j + 1) begin  
                    if (adj_matrix[i*N+j] != 8'hFF && current_dist[i] + adj_matrix[i*N+j] < current_dist[j]) begin  
                        current_dist[j] = current_dist[i] + adj_matrix[i*N+j];  
                    end  
                end  
            end  
        end  
  
        // Assign final distances  
        for (i = 0; i < N; i = i + 1) begin  
            dist[i] = current_dist[i];  
        end  
    end  
endmodule