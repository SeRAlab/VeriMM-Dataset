module wallace_tree_multiplier (  
    input [7:0] A,  
    input [7:0] B,  
    output [15:0] product  
);  

    wire [15:0] partial [0:7];  
    wire [15:0] sum [0:7];  
    wire [7:0] carry;  

    // Generate partial products  
    genvar i;  
    generate  
        for (i = 0; i < 8; i = i + 1) begin: gen_partial_products  
            assign partial[i] = A * {8'b0, B[i]};  
        end  
    endgenerate  

    // Wallace tree reduction  
    // First level reduction  
    assign sum[0] = partial[0] + partial[1];  
    assign carry[0] = sum[0][15];  
    assign sum[1] = partial[2] + partial[3];  
    assign carry[1] = sum[1][15];  
    assign sum[2] = partial[4] + partial[5];  
    assign carry[2] = sum[2][15];  
    assign sum[3] = partial[6] + partial[7];  
    assign carry[3] = sum[3][15];  

    // Second level reduction  
    assign sum[4] = sum[0][14:0] + sum[1][14:0] + carry[0];  
    assign sum[5] = sum[2][14:0] + sum[3][14:0] + carry[1];  

    // Final level reduction  
    assign product = {sum[4][14:0] + sum[5][14:0] + carry[2], carry[3]};  

endmodule