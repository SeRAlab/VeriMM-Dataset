module dijkstra #(parameter N = 5) (  
    input wire [N*N-1:0] adjacency_matrix,  
    input wire [2:0] start_vertex,  
    output reg [N-1:0] distances  
);  
    integer i, j;  
    reg [N-1:0] visited;  
    reg [N-1:0] current_distance;  
    reg [N-1:0] next_vertex;  
  
    always @(*) begin  
        // Initialize distances and visited  
        distances = {N{1'b1}}; // Set all distances to infinity  
        visited = 0;  
        distances[start_vertex] = 0; // Distance to self is 0  
  
        // Dijkstra's algorithm implementation  
        for (i = 0; i < N; i = i + 1) begin  
            // Find the vertex with the minimum distance  
            current_distance = 8'hFF;  
            next_vertex = 0;  
            for (j = 0; j < N; j = j + 1) begin  
                if (!visited[j] && distances[j] < current_distance) begin  
                    current_distance = distances[j];  
                    next_vertex = j;  
                end  
            end  
            visited[next_vertex] = 1;  
  
            // Update distances to neighboring vertices  
            for (j = 0; j < N; j = j + 1) begin  
                if (adjacency_matrix[next_vertex * N + j] > 0 && !visited[j]) begin  
                    if (distances[next_vertex] + adjacency_matrix[next_vertex * N + j] < distances[j]) begin  
                        distances[j] = distances[next_vertex] + adjacency_matrix[next_vertex * N + j];  
                    end  
                end  
            end  
        end  
    end  
endmodule