module gaussian_blur (
    input [7:0] p00, p01, p02,
    input [7:0] p10, p11, p12,
    input [7:0] p20, p21, p22,
    output reg [7:0] blurred_pixel
);
    
    always @(*) begin
        blurred_pixel = (p00 + (p01 << 1) + p02 + 
                         (p10 << 1) + (p11 << 2) + (p12 << 1) + 
                         (p20 + (p21 << 1) + p22)) / 16;
    end
endmodule