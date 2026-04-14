module dijkstra (
    input [24:0] adj_matrix,  // 5x5 adjacency matrix (25 bits)
    output reg [4:0] shortest_paths // 5 shortest path outputs
);
    integer i, j;
    reg [4:0] dist; // distances
    reg [4:0] visited; // visited nodes
    reg [4:0] min_dist;
    reg [4:0] current_node;

    always @(*) begin
        // Initialize distances and visited nodes
        dist = 5'b11111; // Start with infinity
        visited = 5'b00000; // No nodes visited
        dist[0] = 5'b00000; // Distance to source is 0

        for (i = 0; i < 5; i = i + 1) begin
            // Find the unvisited node with the smallest distance
            min_dist = 5'b11111;
            for (j = 0; j < 5; j = j + 1) begin
                if (!visited[j] && (dist[j] < min_dist)) begin
                    min_dist = dist[j];
                    current_node = j;
                end
            end

            // Mark the current node as visited
            visited[current_node] = 1;

            // Update distances for neighboring nodes
            for (j = 0; j < 5; j = j + 1) begin
                if (adj_matrix[current_node * 5 + j] && !visited[j]) begin
                    if (dist[current_node] + adj_matrix[current_node * 5 + j] < dist[j]) begin
                        dist[j] = dist[current_node] + adj_matrix[current_node * 5 + j];
                    end
                end
            end
        end

        // Assign the shortest paths to output
        shortest_paths = dist;
    end
endmodule