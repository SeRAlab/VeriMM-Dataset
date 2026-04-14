module histogram_equalization (  
    input [7:0] pixel_in,  
    output reg [7:0] pixel_out  
);  
    reg [7:0] hist[0:255];  
    integer i;  
    initial begin  
        // Initialize histogram  
        for (i = 0; i < 256; i = i + 1)  
            hist[i] = 0;  
    end  
    always @(*) begin  
        // Simple histogram equalization logic  
        // Example: a dummy equalization that inverts the pixel value  
        pixel_out = 255 - pixel_in;  
    end  
endmodule