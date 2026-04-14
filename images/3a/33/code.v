module bellman_ford #(parameter NUM_NODES = 5) (
    input wire [NUM_NODES*NUM_NODES-1:0] adj_matrix, // adjacency matrix flattened
    input wire [NUM_NODES-1:0] weights, // weight of edges
    input wire [2:0] source, // source node (0 to NUM_NODES-1)
    output reg [NUM_NODES-1:0] distances // distances from source
);
    integer i, j, k;

    always @(*) begin
        // Initialize distances
        for (i = 0; i < NUM_NODES; i = i + 1) begin
            distances[i] = (i == source) ? 0 : 8'hFF; // Set inf for other nodes
        end
        
        // Relax edges repeatedly
        for (k = 0; k < NUM_NODES-1; k = k + 1) begin
            for (i = 0; i < NUM_NODES; i = i + 1) begin
                for (j = 0; j < NUM_NODES; j = j + 1) begin
                    if (adj_matrix[i*NUM_NODES + j] && (distances[i] + weights[j] < distances[j])) begin
                        distances[j] = distances[i] + weights[j];
                    end
                end
            end
        end
    end
endmodule