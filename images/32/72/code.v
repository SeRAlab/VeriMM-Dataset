module floyd_warshall #(parameter N=4) (  
    input clk,  
    input reset,  
    input [N*N*16-1:0] weights,  
    output reg [N*N*16-1:0] shortest_paths  
);  
    reg [N*N*16-1:0] dist;  
    integer i, j, k;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            shortest_paths <= weights;  
        end else begin  
            dist <= shortest_paths;  
            for (k = 0; k < N; k = k + 1) begin  
                for (i = 0; i < N; i = i + 1) begin  
                    for (j = 0; j < N; j = j + 1) begin  
                        if (dist[i*N + k] + dist[k*N + j] < dist[i*N + j]) begin  
                            shortest_paths[i*N + j] <= dist[i*N + k] + dist[k*N + j];  
                        end  
                    end  
                end  
            end  
        end  
    end  
endmodule