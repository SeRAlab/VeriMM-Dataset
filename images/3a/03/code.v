module floyd_warshall(  
    input [15:0] adj_matrix,  
    output reg [15:0] shortest_paths  
);  
    integer i, j, k;  
    reg [3:0] dist [0:3][0:3];  

    always @* begin  
        // Initialize the distance matrix with the adjacency matrix  
        for (i = 0; i < 4; i = i + 1) begin  
            for (j = 0; j < 4; j = j + 1) begin  
                if (i == j)  
                    dist[i][j] = 0;  
                else  
                    dist[i][j] = adj_matrix[i * 4 + j];  
            end  
        end  

        // Floyd-Warshall algorithm  
        for (k = 0; k < 4; k = k + 1) begin  
            for (i = 0; i < 4; i = i + 1) begin  
                for (j = 0; j < 4; j = j + 1) begin  
                    if (dist[i][k] + dist[k][j] < dist[i][j])  
                        dist[i][j] = dist[i][k] + dist[k][j];  
                end  
            end  
        end  

        // Output the shortest paths as a flat 16-bit vector  
        for (i = 0; i < 4; i = i + 1) begin  
            for (j = 0; j < 4; j = j + 1) begin  
                shortest_paths[i * 4 + j] = dist[i][j];  
            end  
        end  
    end  
endmodule