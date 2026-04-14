module bellman_ford #(parameter N = 5) (  
    input [N-1:0] edges,  
    input [N-1:0] weights,  
    input [N-1:0] src,  
    output reg [N-1:0] dist  
);  
    integer i, j;  
    initial begin  
        // Initialize distances to infinity  
        for (i = 0; i < N; i = i + 1) begin  
            dist[i] = 8'hFF; // Assume 8'hFF represents infinity  
        end  
        dist[src] = 0; // Distance to source is 0  
      
        // Relax edges N-1 times  
        for (i = 0; i < N-1; i = i + 1) begin  
            for (j = 0; j < N; j = j + 1) begin  
                // Relaxation logic  
                if (dist[edges[j]] > dist[i] + weights[j]) begin  
                    dist[edges[j]] = dist[i] + weights[j];  
                end  
            end  
        end  
    end  
endmodule