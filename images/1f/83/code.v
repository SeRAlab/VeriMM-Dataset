module graph_coloring (
    input [3:0] edges,  // 4 bits, each bit represents an edge between vertex i and j (i < j)
    output reg [3:0] colors // 2 bits for each of the 4 vertices
);
    integer i, j;

    always @(*) begin
        // Initialize colors
        colors = 4'b0000;
        
        // Assign colors based on edges
        for (i = 0; i < 4; i = i + 1) begin
            for (j = 0; j < 4; j = j + 1) begin
                if (edges[i*4+j] && colors[i] == colors[j]) begin
                    colors[j] = ~colors[i]; // Assign opposite color
                end
            end
        end
    end
endmodule