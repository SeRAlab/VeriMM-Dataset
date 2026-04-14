module min_weight_edge (
    input [3:0] edge0,
    input [3:0] edge1,
    input [3:0] edge2,
    input [3:0] edge3,
    input [3:0] edge4,
    output reg [3:0] min_edge
);
    always @(*) begin
        min_edge = edge0; // Start with the first edge as the minimum
        if (edge1 < min_edge) min_edge = edge1;
        if (edge2 < min_edge) min_edge = edge2;
        if (edge3 < min_edge) min_edge = edge3;
        if (edge4 < min_edge) min_edge = edge4;
    end
endmodule