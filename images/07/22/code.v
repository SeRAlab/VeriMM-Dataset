module dijkstra #(parameter N = 4) (  
    input clk,  
    input rst,  
    input [N*N-1:0] adj_matrix,  
    input [N-1:0] source,  
    output reg [N-1:0] shortest_distances,  
    output reg [N*N-1:0] paths  
);  
    reg [N-1:0] visited;  
    reg [N-1:0] dist;  
    integer i, j;  
    reg [N-1:0] prev;  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            visited <= 0;  
            dist <= {N{1'b1}};  
            dist[source] <= 0;  
            paths <= 0;  
        end else begin  
            for (i = 0; i < N; i = i + 1) begin  
                if (!visited[i] && dist[i] < dist[source]) begin  
                    visited[i] <= 1;  
                    for (j = 0; j < N; j = j + 1) begin  
                        if (adj_matrix[i*N+j] && !visited[j] && dist[i] + adj_matrix[i*N+j] < dist[j]) begin  
                            dist[j] <= dist[i] + adj_matrix[i*N+j];  
                            paths[j] <= i;  
                        end  
                    end  
                end  
            end  
        end  
    end  

    always @(posedge clk) begin  
        shortest_distances <= dist;  
    end  
endmodule