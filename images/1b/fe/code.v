module dijkstra(
    input [15:0] adj_matrix, // 4x4 adjacency matrix (16 bits)
    output reg [3:0] dist,   // Shortest distances to each node (4 bits)
    output reg [3:0] visited  // Visited nodes (4 bits)
);
    integer i, j;
    reg [3:0] current_dist [0:3];
    reg [3:0] min_dist;
    reg [3:0] current_node;

    always @(*) begin
        // Initialize distances and visited
        for (i = 0; i < 4; i = i + 1) begin
            current_dist[i] = (i == 0) ? 0 : 4'b1111; // Set distance to self as 0, others as infinity
            visited[i] = 0;
        end

        // Dijkstra's Algorithm
        for (i = 0; i < 4; i = i + 1) begin
            min_dist = 4'b1111;
            current_node = 4'b0000;

            // Find the unvisited node with the smallest distance
            for (j = 0; j < 4; j = j + 1) begin
                if (!visited[j] && current_dist[j] < min_dist) begin
                    min_dist = current_dist[j];
                    current_node = j;
                end
            end

            // Mark the current node as visited
            visited[current_node] = 1;

            // Update distances to neighboring nodes
            for (j = 0; j < 4; j = j + 1) begin
                if (!visited[j] && (adj_matrix[current_node * 4 + j] != 0)) begin
                    if (current_dist[current_node] + adj_matrix[current_node * 4 + j] < current_dist[j]) begin
                        current_dist[j] = current_dist[current_node] + adj_matrix[current_node * 4 + j];
                    end
                end
            end
        end

        // Output final distances
        dist = {current_dist[3], current_dist[2], current_dist[1], current_dist[0]};
    end
endmodule