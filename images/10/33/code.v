module kruskal_mst #(parameter N = 5) (
    input [N-1:0] weights, // Input weights of the edges
    input [N-1:0] included_edges, // Edges already included in the MST
    output reg can_include // Output signal indicating if the edge can be included
);
    
    integer i;
    reg cycle_detected;
    
    always @(*) begin
        cycle_detected = 0;
        can_include = 0;

        // Check if the new edge can be included without forming a cycle
        for (i = 0; i < N; i = i + 1) begin
            if (included_edges[i] && (weights[i] < weights[N])) begin // Assuming weights[N] is the weight of the new edge
                cycle_detected = 1;
            end
        end
        can_include = !cycle_detected; // Can include if no cycle detected
    end
endmodule