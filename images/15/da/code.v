module Dijkstra #(parameter N = 5) (  
    input  [N*N-1:0] adj_matrix,  // Adjacency matrix (flattened)  
    input  [2:0] src,              // Source vertex (3-bit for 0 to 4)  
    output reg [N-1:0] dist        // Shortest path distances  
);  
    integer i, j;  
    reg [N-1:0] visited;  
    reg [N-1:0] temp_dist;  
    reg [N-1:0] min_dist;  
    reg [2:0] min_index;  
  
    always @(*) begin  
        visited = 0;  
        dist = {N{1'b1}}; // Initialize distances to infinity  
        dist[src] = 0;    // Distance to source is 0  
  
        for (i = 0; i < N; i = i + 1) begin  
            min_dist = 1'b1;  
            for (j = 0; j < N; j = j + 1) begin  
                if (!visited[j] && (dist[j] < min_dist)) begin  
                    min_dist = dist[j];  
                    min_index = j;  
                end  
            end  
            visited[min_index] = 1;  
  
            for (j = 0; j < N; j = j + 1) begin  
                if (adj_matrix[min_index*N + j] > 0 && !visited[j]) begin  
                    if (dist[min_index] + adj_matrix[min_index*N + j] < dist[j]) begin  
                        dist[j] = dist[min_index] + adj_matrix[min_index*N + j];  
                    end  
                end  
            end  
        end  
    end  
endmodule