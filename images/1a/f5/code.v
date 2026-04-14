module dijkstra_min_vertex(
    input [3:0] current_vertex,
    input [15:0] distances, // 4 vertices, each 4 bits
    output reg [3:0] min_vertex
);
    integer i;
    reg [3:0] min_distance;
    initial begin
        min_distance = 4'b1111; // Initialize to max
        min_vertex = 4'b0000; // Default output
    end
    
    always @(*) begin
        min_distance = 4'b1111; // Reset min_distance on input change
        min_vertex = 4'b0000; // Reset min_vertex on input change
        
        for (i = 0; i < 4; i = i + 1) begin
            if (distances[i*4 +: 4] < min_distance && i != current_vertex) begin
                min_distance = distances[i*4 +: 4];
                min_vertex = i;
            end
        end
    end
endmodule