module nearest_neighbor_interpolation(
    input [7:0] pixel,     // Current pixel value
    input [7:0] up,        // Upper neighbor pixel value
    input [7:0] down,      // Lower neighbor pixel value
    input [7:0] left,      // Left neighbor pixel value
    input [7:0] right,     // Right neighbor pixel value
    output reg [7:0] out   // Interpolated pixel value
);
    
    always @(*) begin
        if (pixel != 8'b0) begin
            out = pixel; // If the current pixel is not zero, retain its value.
        end else begin
            // Check neighboring pixels
            if (up != 8'b0) out = up;
            else if (down != 8'b0) out = down;
            else if (left != 8'b0) out = left;
            else if (right != 8'b0) out = right;
            else out = 8'b0; // If all neighbors are zero, output zero.
        end
    end
endmodule