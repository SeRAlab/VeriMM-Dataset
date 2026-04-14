module FloydWarshall #(parameter N=4) (  
    input [N*N*8-1:0] weights,  
    output reg [N*N*8-1:0] shortest_paths  
);  
    integer i, j, k;  
    reg [7:0] dist [0:N-1][0:N-1];  

    always @* begin  
        // Initialize the distance matrix  
        for (i = 0; i < N; i = i + 1) begin  
            for (j = 0; j < N; j = j + 1) begin  
                if (i == j)  
                    dist[i][j] = 8'b0;  
                else  
                    dist[i][j] = weights[(i*N+j)*8 +: 8];  
            end  
        end  

        // Floyd-Warshall algorithm  
        for (k = 0; k < N; k = k + 1) begin  
            for (i = 0; i < N; i = i + 1) begin  
                for (j = 0; j < N; j = j + 1) begin  
                    if (dist[i][j] > dist[i][k] + dist[k][j]) begin  
                        dist[i][j] = dist[i][k] + dist[k][j];  
                    end  
                end  
            end  
        end  

        // Flatten the distance matrix to output  
        for (i = 0; i < N; i = i + 1) begin  
            for (j = 0; j < N; j = j + 1) begin  
                shortest_paths[(i*N+j)*8 +: 8] = dist[i][j];  
            end  
        end  
    end  
endmodule