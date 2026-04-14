module float_multiplier (  
    input [31:0] a,  
    input [31:0] b,  
    output reg [31:0] product  
);  

    wire sign_a, sign_b;  
    wire [7:0] exp_a, exp_b;  
    wire [23:0] mant_a, mant_b;  
    wire [7:0] exp_product;  
    wire [47:0] mant_product;  
    wire product_sign;  
    wire [23:0] mant_product_normalized;  
    wire [7:0] exp_product_normalized;  
    wire [7:0] exp_adjusted;  

    assign sign_a = a[31];  
    assign sign_b = b[31];  
    assign exp_a = a[30:23];  
    assign exp_b = b[30:23];  
    assign mant_a = {1'b1, a[22:0]};  // implicit leading 1 for normalized numbers  
    assign mant_b = {1'b1, b[22:0]};  

    assign product_sign = sign_a ^ sign_b;  
    assign exp_product = exp_a + exp_b - 8'd127;  
    assign mant_product = mant_a * mant_b;  

    assign mant_product_normalized = mant_product[47:24];  
    assign exp_adjusted = exp_product + (mant_product[47] ? 1 : 0);  

    always @* begin  
        if (mant_product[47]) begin  
            product <= {product_sign, exp_adjusted, mant_product_normalized[22:0]};  
        end else begin  
            product <= {product_sign, exp_product, mant_product[46:24]};  
        end  
    end  
endmodule