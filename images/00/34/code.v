module prim_mst (
    input [15:0] adj_matrix, // 4x4 adjacency matrix (16 bits total)
    output reg [7:0] mst_edges // Output format: {edge1, edge2, edge3, edge4}
);

    reg [3:0] included; // Tracks included vertices
    integer i, j, min_edge, u, v;
    integer edges_count;
    
    always @(*) begin
        included = 4'b0001; // Start with the first vertex included
        mst_edges = 8'b0;
        edges_count = 0;

        for (i = 0; i < 3; i = i + 1) begin
            min_edge = 999; // Arbitrary large value
            u = 0; v = 0;

            for (j = 0; j < 4; j = j + 1) begin
                if (included[j]) begin
                    // Check adjacent vertices
                    for (v = 0; v < 4; v = v + 1) begin
                        if (!included[v] && adj_matrix[j*4 + v] > 0 && adj_matrix[j*4 + v] < min_edge) begin
                            min_edge = adj_matrix[j*4 + v];
                            u = j;
                            v = v;
                        end
                    end
                end
            end

            included[v] = 1; // Include the chosen vertex in the MST
            mst_edges[edges_count*2 +: 2] = {u, v}; 
            edges_count = edges_count + 1;
        end
    end
endmodule