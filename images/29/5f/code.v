module dijkstra (
    input clk,
    input rst,
    input [2:0] source,  // source node (0 to 4)
    input [24:0] adj_matrix,  // flattened 5x5 adjacency matrix
    output reg [4:0] min_distances, // output distances from source to each node
    output reg done
);
    reg [4:0] distances; // current known distances
    reg [4:0] visited; // visited nodes
    reg [2:0] current_node; // current node being processed

    integer i;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            distances <= 5'b11111; // initialize to max (infinity)
            visited <= 5'b00000;
            min_distances <= 5'b00000;
            done <= 0;
            current_node <= source;
            distances[source] <= 0; // distance to source is 0
        end else if (!done) begin
            // Find the unvisited node with the smallest distance
            current_node = 0;
            for (i = 1; i < 5; i = i + 1) begin
                if (!visited[i] && (distances[i] < distances[current_node])) begin
                    current_node = i;
                end
            end

            visited[current_node] = 1; // mark as visited
            
            // Update distances for neighbors
            for (i = 0; i < 5; i = i + 1) begin
                if (adj_matrix[current_node * 5 + i] != 0 && !visited[i]) begin
                    if (distances[current_node] + adj_matrix[current_node * 5 + i] < distances[i]) begin
                        distances[i] <= distances[current_node] + adj_matrix[current_node * 5 + i];
                    end
                end
            end
            
            // Check if all nodes are visited
            if (visited == 5'b11111) begin
                done <= 1;
                min_distances <= distances; // output final distances
            end
        end
    end
endmodule