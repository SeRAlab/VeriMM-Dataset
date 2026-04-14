module erosion_3x3(
    input [8:0] image, // 3x3 binary image
    output reg result   // Erosion result
);

always @(*) begin
    // Erosion condition: all pixels must be 1
    if (image == 9'b111111111) 
        result = 1'b1; // Erosion successful
    else 
        result = 1'b0; // Erosion failed
end

endmodule