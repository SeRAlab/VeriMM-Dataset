module histogram_equalization(  
    input [7:0] pixel_in,  
    output reg [7:0] pixel_out  
);  
    reg [31:0] histogram [0:255];  
    reg [31:0] cdf [0:255];  
    integer i;  
    integer total_pixels = 256; // For simplicity, assume all 256 values are present.  

    always @(*) begin  
        // Initialize histogram  
        for (i = 0; i < 256; i = i + 1) begin  
            histogram[i] = 0;  
            cdf[i] = 0;  
        end  
        
        // Construct histogram from pixel_in  
        histogram[pixel_in] = histogram[pixel_in] + 1;  
        
        // Construct CDF  
        cdf[0] = histogram[0];  
        for (i = 1; i < 256; i = i + 1) begin  
            cdf[i] = cdf[i-1] + histogram[i];  
        end  

        // Normalize CDF and assign to pixel_out  
        pixel_out = (cdf[pixel_in] * 255) / total_pixels;  
    end  
endmodule