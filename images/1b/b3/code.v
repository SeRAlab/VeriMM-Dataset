module gaussian_blur(
    input [7:0] p00, p01, p02,
    input [7:0] p10, p11, p12,
    input [7:0] p20, p21, p22,
    output reg [7:0] blurred_pixel
);
    always @(*) begin
        blurred_pixel = (p00 + 2*p01 + p02 + 
                        2*p10 + 4*p11 + 2*p12 + 
                        p20 + 2*p21 + p22) / 16;
    end
endmodule