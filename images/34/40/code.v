module graph_coloring (
    input [8:0] adjacency_matrix, // 3x3 matrix for 3 vertices
    output reg [2:0] colors // 3 colors for each vertex
);
    always @(*) begin
        case (adjacency_matrix)
            9'b000000000: colors = 3'b000; // No edges
            9'b000000001: colors = 3'b001; // 1 connected to 0
            9'b000001000: colors = 3'b010; // 0 connected to 2
            9'b000010000: colors = 3'b100; // 1 connected to 2
            9'b000011000: colors = 3'b010; // 0 connected to 1 and 2
            9'b000100000: colors = 3'b001; // 2 connected to 1
            default: colors = 3'bxxx; // Undefined case
        endcase
    end
endmodule