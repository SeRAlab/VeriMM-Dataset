module bilinear_interpolation (
    input [7:0] P00, // Pixel value at (x0, y0)
    input [7:0] P01, // Pixel value at (x0, y1)
    input [7:0] P10, // Pixel value at (x1, y0)
    input [7:0] P11, // Pixel value at (x1, y1)
    output [7:0] P_out // Interpolated pixel value
);
    wire [15:0] P0_avg, P1_avg; // Intermediate averages

    // Calculate the average of the pixel values
    assign P0_avg = P00 + P01;
    assign P1_avg = P10 + P11;

    // Final interpolation calculation
    assign P_out = (P0_avg + P1_avg) >> 2; // Average of averages

endmodule