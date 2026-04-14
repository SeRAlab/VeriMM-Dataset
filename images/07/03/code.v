module bellman_ford #(parameter N = 10, M = 5) (  
    input clk,  
    input rst,  
    input [M-1:0] edges_valid,  
    input [M-1:0] src_vertex,  
    input [N*2-1:0] edges, // {src0, dest0, weight0, src1, dest1, weight1, ...}  
    output reg [M*16-1:0] shortest_paths, // Output shortest paths for each vertex  
    output reg done  
);  
    reg [M*16-1:0] dist;  
    reg [M-1:0] updated;  
    integer i, j;  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            dist <= {M{16'hFFFF}}; // Initialize all distances to 'infinity'  
            dist[src_vertex] <= 0; // Distance to source is 0  
            done <= 0;  
        end else begin  
            updated = 0;  
            for (i = 0; i < N; i = i + 1) begin  
                if (edges_valid[i]) begin  
                    for (j = 0; j < M; j = j + 1) begin  
                        if (dist[edges[j*3]] + edges[j*3 + 2] < dist[edges[j*3 + 1]]) begin  
                            dist[edges[j*3 + 1]] <= dist[edges[j*3]] + edges[j*3 + 2];  
                            updated[j] <= 1;  
                        end  
                    end  
                end  
            end  
            if (!updated) begin  
                done <= 1; // No more updates, algorithm finished  
            end  
        end  
    end  

    always @(*) begin  
        shortest_paths = dist;  
    end  
endmodule