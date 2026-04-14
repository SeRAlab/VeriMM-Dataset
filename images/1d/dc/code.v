module bilinear_interpolation (
    input [7:0] A, // pixel value at (0,0)
    input [7:0] B, // pixel value at (0,1)
    input [7:0] C, // pixel value at (1,0)
    input [7:0] D, // pixel value at (1,1)
    input [7:0] u, // horizontal interpolation factor
    input [7:0] v, // vertical interpolation factor
    output reg [7:0] out // interpolated pixel value
);
    always @(*) begin
        // Calculate the interpolated value
        // Using fixed-point arithmetic: (A * (1-u) * (1-v)) + (B * (1-u) * v) + (C * u * (1-v)) + (D * u * v)
        out = (A * (255-u) * (255-v) + 
               B * (255-u) * v + 
               C * u * (255-v) + 
               D * u * v) >> 16; // Right shift to normalize the result
    end
endmodule