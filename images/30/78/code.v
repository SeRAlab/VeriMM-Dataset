module bellman_ford (
    input [4:0] edges, // 5-bit input representing edges as a packed vector
    input [4:0] weights, // 5-bit input representing weights of edges
    input [2:0] source, // 3-bit input for the source vertex (0-4)
    output reg [4:0] distances // 5-bit output for distances to each vertex
);
    integer i;
    reg [4:0] temp_distances;

    always @(*) begin
        // Initialize distances to infinity, except for the source
        distances = 5'b11111; // 31 in decimal represents infinity
        distances[source] = 5'b00000; // Distance to self is 0

        // Relax edges up to 5 times
        for (i = 0; i < 5; i = i + 1) begin
            temp_distances = distances;
            // For each edge
            if (edges[i] == 1'b1) begin
                // Check if we can relax the edge
                if (temp_distances[i] + weights[i] < distances[i]) begin
                    distances[i] = temp_distances[i] + weights[i];
                end
            end
        end
    end
endmodule