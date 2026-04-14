module dilation_3x3 (
    input [8:0] img,  // 3x3 binary image input
    output reg out     // Output of dilation
);
    always @* begin
        out = img[0] | img[1] | img[2] |
              img[3] | img[4] | img[5] |
              img[6] | img[7] | img[8];
    end
endmodule