module prim_mst (
    input [0:124] adj_matrix, // 5x5 adjacency matrix flattened
    output reg [0:63] mst_edges // Output edges of the MST
);
    parameter MAX_WEIGHT = 8'hFF; 
    reg [3:0] selected_vertices;
    reg [7:0] min_edge_weight;
    reg [2:0] u, v;
    reg [2:0] edge_count;

    initial begin
        selected_vertices = 4'b00001; // Start from vertex 0
        edge_count = 0;
        mst_edges = 0;
    end

    always @(*) begin
        for (edge_count = 0; edge_count < 4; edge_count = edge_count + 1) begin
            min_edge_weight = MAX_WEIGHT;
            for (u = 0; u < 5; u = u + 1) begin
                if (selected_vertices[u]) begin
                    for (v = 0; v < 5; v = v + 1) begin
                        if (!selected_vertices[v] && (adj_matrix[25*u + v] > 0) && (adj_matrix[25*u + v] < min_edge_weight)) begin
                            min_edge_weight = adj_matrix[25*u + v];
                            mst_edges[16*edge_count +: 16] = {u, v}; // Store edge in the output
                        end
                    end
                end
            end
            selected_vertices[v] = 1; // Mark vertex v as included in MST
        end
    end
endmodule