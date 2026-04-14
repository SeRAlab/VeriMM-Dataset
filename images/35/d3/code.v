module morphological_erosion (
    input [8:0] img, // 3x3 binary image input flattened
    output reg out    // single binary output
);
    always @(*) begin
        // Check all 9 bits of the 3x3 matrix
        if (img == 9'b111111111)
            out = 1'b1; // Erosion output is 1 if all pixels are 1
        else
            out = 1'b0; // Otherwise, output is 0
    end
endmodule