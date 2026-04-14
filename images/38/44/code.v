module morphological_erosion (
    input  [8:0] img,  // 3x3 binary image flattened (9 bits)
    output reg       eroded_pixel // Output pixel after erosion
);
    always @(*) begin
        // Erosion with a structuring element
        if (img[0] && img[1] && img[2] &&
            img[3] && img[4] && img[5] &&
            img[6] && img[7] && img[8]) begin
            eroded_pixel = 1'b1; // Erosion successful
        end else begin
            eroded_pixel = 1'b0; // Erosion not successful
        end
    end
endmodule