module dijkstra (
    input [15:0] adj_matrix, // 4x4 adjacency matrix, 0 if no edge
    input [1:0] start_node,  // 2-bit starting node (0 to 3)
    output reg [3:0] shortest_paths // 4-bit shortest paths outputs
);
    integer i, j, k;
    reg [3:0] dist;
    reg [3:0] visited;
    reg [3:0] min_dist;
    
    always @(*) begin
        // Initialize distances and visited
        dist = 4'b1111; // Infinity
        visited = 4'b0000; // No nodes visited
        dist[start_node] = 0; // Distance to start node is 0
        
        for (k = 0; k < 4; k = k + 1) begin
            // Find the minimum distance node
            min_dist = 4'b1111; // Reset minimum distance
            for (i = 0; i < 4; i = i + 1) begin
                if (!visited[i] && dist[i] < min_dist) begin
                    min_dist = dist[i];
                    j = i; // j is the node with minimum distance
                end
            end
            
            visited[j] = 1; // Mark node as visited
            
            // Update distances
            for (i = 0; i < 4; i = i + 1) begin
                if (!visited[i] && adj_matrix[j*4 + i] > 0) begin
                    if (dist[j] + adj_matrix[j*4 + i] < dist[i]) begin
                        dist[i] = dist[j] + adj_matrix[j*4 + i];
                    end
                end
            end
        end
        
        // Assign the shortest distances to output
        shortest_paths = dist;
    end
endmodule