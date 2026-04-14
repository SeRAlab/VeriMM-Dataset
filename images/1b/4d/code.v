module dilation_3x3 (
    input [0:8] img,   // 3x3 image represented as a 9-bit vector
    output reg out     // Output of the dilation operation
);
    always @(*) begin
        out = (img[0] | img[1] | img[2] | 
               img[3] | img[4] | img[5] | 
               img[6] | img[7] | img[8]);
    end
endmodule