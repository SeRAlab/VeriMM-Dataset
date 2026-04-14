module Prim_MST (
    input [0:24] adjacency_matrix,  // 5x5 adjacency matrix (5 nodes)
    output reg [0:19] mst_edges      // Output edges of the MST in the format {u,v}
);
    integer i, j, k;
    reg [0:4] selected;               // Track selected nodes
    reg [0:4] parent;                 // Parent nodes in the MST
    reg [0:4] key;                    // Key values to pick minimum weight edge
    initial begin
        selected = 5'b00000;
        parent = 5'b00000;
        key = {5{1'b1}}; // Set all keys to infinity
        key[0] = 0;      // Start from the first node (node 0)
        for (i = 0; i < 5; i = i + 1) begin
            // Find the minimum key vertex
            k = 0;
            for (j = 1; j < 5; j = j + 1) begin
                if (!selected[j] && key[j] < key[k]) begin
                    k = j;
                end
            end
            selected[k] = 1; // Pick the minimum key vertex
            // Update key values and parent index of the adjacent vertices
            for (j = 0; j < 5; j = j + 1) begin
                if (adjacency_matrix[k*5+j] && !selected[j] && adjacency_matrix[k*5+j] < key[j]) begin
                    parent[j] = k; // Update parent
                    key[j] = adjacency_matrix[k*5+j]; // Update key
                end
            end
        end
        // Format output edges
        mst_edges = {parent[1], 1'b0, parent[2], 1'b0, parent[3], 1'b0, parent[4]};
    end
endmodule