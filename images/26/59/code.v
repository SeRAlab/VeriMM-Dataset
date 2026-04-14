module floyd_warshall #(parameter N = 4)  
(  
    input [N*N-1:0] distance_in,  
    output reg [N*N-1:0] distance_out  
);  
  
    integer i, j, k;  
    reg [N*N-1:0] dist [0:N-1];  
  
    always @(*) begin  
        // Initialize distance matrix  
        for (i = 0; i < N; i = i + 1) begin  
            for (j = 0; j < N; j = j + 1) begin  
                if (i == j)  
                    dist[i][j] = 0;  
                else  
                    dist[i][j] = distance_in[i*N + j];  
            end  
        end  
  
        // Floyd-Warshall algorithm  
        for (k = 0; k < N; k = k + 1) begin  
            for (i = 0; i < N; i = i + 1) begin  
                for (j = 0; j < N; j = j + 1) begin  
                    if (dist[i][j] > dist[i][k] + dist[k][j])  
                        dist[i][j] = dist[i][k] + dist[k][j];  
                end  
            end  
        end  
  
        // Output the result  
        for (i = 0; i < N; i = i + 1) begin  
            for (j = 0; j < N; j = j + 1) begin  
                distance_out[i*N + j] = dist[i][j];  
            end  
        end  
    end  
endmodule