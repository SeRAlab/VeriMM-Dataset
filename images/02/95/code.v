module bellman_ford #(parameter V = 5) (  
    input clk,  
    input reset,  
    input start,  
    input [V*V-1:0] graph_weights,  
    input [2:0] source,  
    output reg [V-1:0] shortest_distances,  
    output reg finished  
);  
    reg [V-1:0] distances;  
    integer i, j;  
    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            distances <= {V{1'b1}}; // Initialize distances to infinity  
            distances[source] <= 0; // Distance to self is 0  
            finished <= 0;  
        end else if (start) begin  
            // Bellman-Ford algorithm iterations  
            for (i = 0; i < V-1; i = i + 1) begin  
                for (j = 0; j < V; j = j + 1) begin  
                    if (graph_weights[j*V + source] != 0 &&  
                        distances[source] + graph_weights[j*V + source] < distances[j]) begin  
                        distances[j] <= distances[source] + graph_weights[j*V + source];  
                    end  
                end  
            end  
            shortest_distances <= distances;  
            finished <= 1;  
        end  
    end  
endmodule