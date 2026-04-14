module knn_classifier (
    input [4:0] in_data,
    output reg [1:0] nearest_neighbor
);

    reg [2:0] neighbors [0:3]; // Define 4 neighbors
    integer i;
    reg [2:0] min_distance;
    reg [1:0] min_index;

    initial begin
        // Predefined 3-bit neighbors
        neighbors[0] = 3'b000;
        neighbors[1] = 3'b101;
        neighbors[2] = 3'b111;
        neighbors[3] = 3'b011;
    end

    always @(*) begin
        min_distance = 3'b111; // maximum possible distance
        min_index = 2'b00;

        for (i = 0; i < 4; i = i + 1) begin
            // Calculate the distance (Hamming distance)
            if (in_data[4:2] != neighbors[i]) begin
                if (min_distance > (in_data[4:2] ^ neighbors[i])) begin
                    min_distance = in_data[4:2] ^ neighbors[i];
                    min_index = i;
                end
            end
        end
        
        nearest_neighbor = min_index;
    end
endmodule