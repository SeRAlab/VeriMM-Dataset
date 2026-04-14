module dijkstra_shortest_path(  
    input [0:24] adjacency_matrix,  
    output reg [0:4] shortest_paths  
);  
    integer i, j, min_index;  
    reg [0:4] distance;  
    reg [0:4] visited;  
    reg [0:4] temp_dist;  
  
    initial begin  
        distance = 5'b11111; // Set initial distances to infinity  
        distance[0] = 0; // Distance to self is zero  
        visited = 5'b00000; // All nodes unvisited  
      
        for (i = 0; i < 5; i = i + 1) begin  
            // Find the unvisited node with the smallest distance  
            min_index = -1;  
            for (j = 0; j < 5; j = j + 1) begin  
                if (!visited[j] && (min_index == -1 || distance[j] < distance[min_index]))  
                    min_index = j;  
            end  
            // Mark the node as visited  
            visited[min_index] = 1'b1;  
            // Update distances for the neighbors  
            for (j = 0; j < 5; j = j + 1) begin  
                if (adjacency_matrix[min_index * 5 + j] != 0 && !visited[j]) begin  
                    temp_dist = distance[min_index] + adjacency_matrix[min_index * 5 + j];  
                    if (temp_dist < distance[j])  
                        distance[j] = temp_dist;  
                end  
            end  
        end  
        shortest_paths = distance;  
    end  
endmodule