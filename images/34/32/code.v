module hough_transform (
    input [63:0] binary_image, // 8x8 binary image
    input [2:0] angle, // 0 for 0 degrees, 1 for 45 degrees, 2 for 90 degrees
    output reg [15:0] accumulator // accumulator for Hough space
);
    integer i, j;
    always @(*) begin
        accumulator = 0; // Initialize accumulator
        for (i = 0; i < 8; i = i + 1) begin
            for (j = 0; j < 8; j = j + 1) begin
                if (binary_image[i*8 + j]) begin // if pixel is set (1)
                    case (angle)
                        3'b000: accumulator = accumulator + 1; // 0 degrees
                        3'b001: accumulator = accumulator + 1; // 45 degrees (simplified)
                        3'b010: accumulator = accumulator + 1; // 90 degrees
                    endcase
                end
            end
        end
    end
endmodule