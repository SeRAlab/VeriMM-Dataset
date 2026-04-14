module dilation_3x3 (  
    input [8:0] img_in,  // 3x3 binary input image (flattened)  
    output reg [8:0] img_out  // 3x3 binary output image (flattened)  
);  
    integer i;  
    always @(*) begin  
        img_out = 0;  
        // Dilation operation  
        for (i = 0; i < 9; i = i + 1) begin  
            if (img_in[i]) begin  
                // Set the current pixel and its neighbors to 1  
                img_out[i] = 1;  
                if (i % 3 > 0) img_out[i - 1] = 1;      // left  
                if (i % 3 < 2) img_out[i + 1] = 1;      // right  
                if (i / 3 > 0) img_out[i - 3] = 1;      // top  
                if (i / 3 < 2) img_out[i + 3] = 1;      // bottom  
                if (i % 3 > 0 && i / 3 > 0) img_out[i - 4] = 1;  // top-left  
                if (i % 3 < 2 && i / 3 > 0) img_out[i - 2] = 1;   // top-right  
                if (i % 3 > 0 && i / 3 < 2) img_out[i + 2] = 1;   // bottom-left  
                if (i % 3 < 2 && i / 3 < 2) img_out[i + 4] = 1;   // bottom-right  
            end  
        end  
    end  
endmodule