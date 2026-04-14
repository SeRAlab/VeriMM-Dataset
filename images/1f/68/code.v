module histogram_equalization(  
    input [255:0] histogram,  
    output reg [255:0] equalized_histogram  
);  
    integer i;  
    reg [31:0] cdf [0:255];  
    reg [31:0] total_pixels;  
  
    always @(*) begin  
        total_pixels = 0;  
        // Compute total number of pixels  
        for (i = 0; i < 256; i = i + 1) begin  
            total_pixels = total_pixels + histogram[i];  
        end  
  
        // Compute CDF  
        cdf[0] = histogram[0];  
        for (i = 1; i < 256; i = i + 1) begin  
            cdf[i] = cdf[i - 1] + histogram[i];  
        end  
  
        // Compute equalized histogram  
        for (i = 0; i < 256; i = i + 1) begin  
            equalized_histogram[i] = (cdf[i] * 255) / total_pixels;  
        end  
    end  
endmodule