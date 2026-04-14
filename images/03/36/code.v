module FloydWarshall #(parameter N = 4, parameter INF = 8'hFF) (  
    input clk,  
    input rst,  
    input [N*N*8-1:0] adjacency_matrix,  
    output reg [N*N*8-1:0] shortest_path_matrix  
);  
    reg [N*N*8-1:0] dist;  
    integer i, j, k;  
      
    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            shortest_path_matrix <= {N*N*8{INF}};  
            for (i = 0; i < N; i = i + 1)  
                shortest_path_matrix[i*N + i] <= 8'h00;  
            dist <= adjacency_matrix;  
        end else begin  
            for (k = 0; k < N; k = k + 1) begin  
                for (i = 0; i < N; i = i + 1) begin  
                    for (j = 0; j < N; j = j + 1) begin  
                        if (dist[i*N + k] + dist[k*N + j] < dist[i*N + j])  
                            dist[i*N + j] <= dist[i*N + k] + dist[k*N + j];  
                    end  
                end  
            end  
            shortest_path_matrix <= dist;  
        end  
    end  
endmodule