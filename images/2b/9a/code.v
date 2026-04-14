module kruskal_mst #(
    parameter NUM_EDGES = 5,
    parameter EDGE_WIDTH = 16,
    parameter VERTEX_WIDTH = 8
) (
    input [NUM_EDGES*EDGE_WIDTH-1:0] edges, // {weight, vertex1, vertex2} for each edge
    output reg [NUM_EDGES*EDGE_WIDTH-1:0] mst_edges // Edges in MST
);

    // Temporary storage for edges and MST
    reg [EDGE_WIDTH-1:0] edge_weight [0:NUM_EDGES-1];
    reg [VERTEX_WIDTH-1:0] edge_vertex1 [0:NUM_EDGES-1];
    reg [VERTEX_WIDTH-1:0] edge_vertex2 [0:NUM_EDGES-1];
    reg [NUM_EDGES-1:0] selected;
    integer i, j;

    initial begin
        // Unpack edges
        for (i = 0; i < NUM_EDGES; i = i + 1) begin
            edge_weight[i] = edges[(i+1)*EDGE_WIDTH-1 -: EDGE_WIDTH];
            edge_vertex1[i] = edges[(i*2+1)*VERTEX_WIDTH-1 -: VERTEX_WIDTH];
            edge_vertex2[i] = edges[(i*2)*VERTEX_WIDTH-1 -: VERTEX_WIDTH];
            selected[i] = 0;
        end
        
        // Simple implementation of Kruskal's algorithm (not optimized)
        // Sort edges by weight
        for (i = 0; i < NUM_EDGES-1; i = i + 1) begin
            for (j = i + 1; j < NUM_EDGES; j = j + 1) begin
                if (edge_weight[i] > edge_weight[j]) begin
                    // Swap edges
                    {edge_weight[i], edge_weight[j]} = {edge_weight[j], edge_weight[i]};
                    {edge_vertex1[i], edge_vertex1[j]} = {edge_vertex1[j], edge_vertex1[i]};
                    {edge_vertex2[i], edge_vertex2[j]} = {edge_vertex2[j], edge_vertex2[i]};
                end
            end
        end

        // Create MST by selecting edges (this is a naive implementation)
        mst_edges = 0;
        for (i = 0; i < NUM_EDGES; i = i + 1) begin
            mst_edges[(i+1)*EDGE_WIDTH-1 -: EDGE_WIDTH] = {edge_weight[i], edge_vertex1[i], edge_vertex2[i]};
        end
    end
endmodule