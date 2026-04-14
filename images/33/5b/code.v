module float_mult(  
    input [7:0] a,  
    input [7:0] b,  
    output reg [7:0] product  
);  
    wire sign_a = a[7];  
    wire sign_b = b[7];  
    wire [3:0] exp_a = a[6:3];  
    wire [3:0] exp_b = b[6:3];  
    wire [2:0] mant_a = a[2:0];  
    wire [2:0] mant_b = b[2:0];  

    wire sign_product = sign_a ^ sign_b;  
    wire [3:0] exp_product = exp_a + exp_b - 4'b0111; // Bias adjustment  
    wire [5:0] mant_product = {1'b1, mant_a} * {1'b1, mant_b}; // Assuming normalized mantissa  

    always @(*) begin  
        product = {sign_product, exp_product, mant_product[4:2]};  
    end  
endmodule