module bellman_ford #(parameter N = 5, E = 8) (  
    input [N-1:0] edges,  
    input [N-1:0] weights,  
    input [N-1:0] source,  
    output reg [N-1:0] distances  
);  
    integer i, j;  
    reg [N-1:0] temp;  

    always @* begin  
        // Initialize distances  
        distances = {N{1'b1}}; // Set all distances to infinity  
        distances[source] = 0; // Distance to source is 0  

        // Bellman-Ford relaxation process  
        for (i = 0; i < N-1; i = i + 1) begin  
            temp = distances;  
            for (j = 0; j < E; j = j + 1) begin  
                if (temp[edges[j]] + weights[j] < distances[edges[j]]) begin  
                    distances[edges[j]] = temp[edges[j]] + weights[j];  
                end  
            end  
        end  
    end  
endmodule