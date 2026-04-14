module dijkstra_shortest_path #(parameter N = 5) (  
    input [N*N-1:0] adj_matrix,  
    input [2:0] source_node,  
    output reg [N-1:0] shortest_distances  
);  
    integer i, j;  
    reg [N-1:0] visited;  
    reg [N-1:0] dist;  
    reg [N-1:0] temp;  
    always @* begin  
        visited = 0;  
        dist = {N{1'b1}};  // Initialize distances to infinity  
        dist[source_node] = 0;  // Distance to source is 0  
          
        for (i = 0; i < N; i = i + 1) begin  
            // Find the minimum distance node  
            temp = {N{1'b1}};  
            for (j = 0; j < N; j = j + 1) begin  
                if (!visited[j] && (dist[j] < temp[j])) begin  
                    temp[j] = dist[j];  
                end  
            end  
              
            // Update the visited node  
            visited[i] = 1;  
              
            // Update the distances  
            for (j = 0; j < N; j = j + 1) begin  
                if (!visited[j] && adj_matrix[i*N + j] > 0 && dist[i] + adj_matrix[i*N + j] < dist[j]) begin  
                    dist[j] = dist[i] + adj_matrix[i*N + j];  
                end  
            end  
        end  
          
        shortest_distances = dist;  
    end  
endmodule