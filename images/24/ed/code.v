module bellman_ford #(parameter N = 5) (  
    input [N*N-1:0] weights, // NxN weight matrix flattened  
    input [2:0] source,      // source vertex (0 to N-1)  
    output reg [N*8-1:0] distances // distances array (8 bits for each vertex)  
);  
    integer i, j, k;  
    reg [7:0] dist [0:N-1];  

    always @(*) begin  
        // Initialize distances  
        for (i = 0; i < N; i = i + 1) begin  
            dist[i] = 8'hFF; // Set to infinity  
        end  
        dist[source] = 8'h00; // Distance to self is 0  

        // Relax edges up to N-1 times  
        for (k = 0; k < N-1; k = k + 1) begin  
            for (i = 0; i < N; i = i + 1) begin  
                for (j = 0; j < N; j = j + 1) begin  
                    if (weights[i*N+j] != 8'hFF && dist[i] != 8'hFF) begin  
                        if (dist[i] + weights[i*N+j] < dist[j]) begin  
                            dist[j] = dist[i] + weights[i*N+j];  
                        end  
                    end  
                end  
            end  
        end  

        // Pack distances into output  
        for (i = 0; i < N; i = i + 1) begin  
            distances[i*8 +: 8] = dist[i];  
        end  
    end  
endmodule