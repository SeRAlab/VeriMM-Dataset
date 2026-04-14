module sobel_edge_detection(  
    input [7:0] pixel00, pixel01, pixel02,  
    input [7:0] pixel10, pixel11, pixel12,  
    input [7:0] pixel20, pixel21, pixel22,  
    output reg [7:0] edge_strength  
);  
    wire signed [10:0] Gx, Gy;  
    wire [10:0] abs_Gx, abs_Gy;  

    // Sobel Kernels  
    assign Gx = (pixel00 * -1) + (pixel01 * 0) + (pixel02 * 1) +  
                (pixel10 * -2) + (pixel11 * 0) + (pixel12 * 2) +  
                (pixel20 * -1) + (pixel21 * 0) + (pixel22 * 1);  

    assign Gy = (pixel00 * -1) + (pixel01 * -2) + (pixel02 * -1) +  
                (pixel10 * 0) + (pixel11 * 0) + (pixel12 * 0) +  
                (pixel20 * 1) + (pixel21 * 2) + (pixel22 * 1);  

    // Absolute values  
    assign abs_Gx = (Gx < 0) ? -Gx : Gx;  
    assign abs_Gy = (Gy < 0) ? -Gy : Gy;  

    // Edge strength  
    always @(*) begin  
        edge_strength = (abs_Gx + abs_Gy > 255) ? 255 : (abs_Gx + abs_Gy);  
    end  
endmodule