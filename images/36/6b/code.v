module dijkstra_shortest_path(
    input [24:0] adj_matrix, // 5x5 adjacency matrix flattened
    input [2:0] start_node, // starting node (0 to 4)
    output reg [4:0] distances // shortest distances to each node
);
    reg [4:0] min_dist;
    reg [4:0] visited;
    integer i, j, current_node;
    
    always @(*) begin
        // Initialize distances and visited nodes
        distances = {5{1'b1}}; // Set all to infinity (e.g., 11111)
        visited = 5'b0; // No nodes visited
        distances[start_node] = 0; // Distance to start node is 0
        
        // Dijkstra's algorithm
        for (i = 0; i < 5; i = i + 1) begin
            // Find the unvisited node with the smallest distance
            min_dist = 5'b11111; // Set to infinity
            current_node = 0;
            for (j = 0; j < 5; j = j + 1) begin
                if (!visited[j] && distances[j] < min_dist) begin
                    min_dist = distances[j];
                    current_node = j;
                end
            end
            
            // Mark the current node as visited
            visited[current_node] = 1'b1;
            
            // Update distances for neighbors
            for (j = 0; j < 5; j = j + 1) begin
                if (!visited[j] && adj_matrix[current_node*5 + j] != 0) begin
                    if (distances[current_node] + adj_matrix[current_node*5 + j] < distances[j]) begin
                        distances[j] = distances[current_node] + adj_matrix[current_node*5 + j];
                    end
                end
            end
        end
    end
endmodule