module morphological_erosion (
    input [24:0] binary_image, // 5x5 binary image flattened
    input [8:0] struct_elem,   // 3x3 structuring element flattened
    output reg [8:0] eroded_image // 3x3 eroded image flattened
);
    integer i, j, m, n;
    always @(*) begin
        eroded_image = 9'b111111111; // start with all 1s, will erode to 0s if needed
        for (i = 0; i < 3; i = i + 1) begin
            for (j = 0; j < 3; j = j + 1) begin
                // Check if the structuring element can be placed
                if (struct_elem[i * 3 + j]) begin
                    // Check the corresponding pixels in the binary image
                    if (!binary_image[(i + 1) * 5 + (j + 1)]) begin
                        eroded_image[i * 3 + j] = 1'b0; // Erode if any pixel is 0
                    end
                end
            end
        end
    end
endmodule