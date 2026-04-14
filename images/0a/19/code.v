module floyd_warshall #(parameter N = 4) (  
    input [N*N*16-1:0] weights,  // 2D array flattened into a 1D input  
    output reg [N*N*16-1:0] distances  
);  
    integer i, j, k;  
    reg [15:0] dist [0:N-1][0:N-1];  

    initial begin  
        // Convert input weights to 2D array  
        for (i = 0; i < N; i = i + 1) begin  
            for (j = 0; j < N; j = j + 1) begin  
                dist[i][j] = weights[(i*N + j)*16 +: 16];  
            end  
        end  

        // Floyd-Warshall algorithm  
        for (k = 0; k < N; k = k + 1) begin  
            for (i = 0; i < N; i = i + 1) begin  
                for (j = 0; j < N; j = j + 1) begin  
                    if (dist[i][k] + dist[k][j] < dist[i][j]) begin  
                        dist[i][j] = dist[i][k] + dist[k][j];  
                    end  
                end  
            end  
        end  

        // Convert 2D array back to 1D output  
        for (i = 0; i < N; i = i + 1) begin  
            for (j = 0; j < N; j = j + 1) begin  
                distances[(i*N + j)*16 +: 16] = dist[i][j];  
            end  
        end  
    end  
endmodule