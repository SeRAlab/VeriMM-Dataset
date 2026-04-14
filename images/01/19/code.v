module FixedPointMultiplier(  
    input [15:0] a,  
    input [15:0] b,  
    output reg [31:0] product  
);  
    reg signed [31:0] temp_product;  
    always @(*) begin  
        temp_product = $signed(a) * $signed(b);  
        // Clamp the product to the maximum and minimum representable values  
        if (temp_product > 32'h7FFFFFFF)  
            product = 32'h7FFFFFFF;  
        else if (temp_product < 32'h80000000)  
            product = 32'h80000000;  
        else  
            product = temp_product;  
    end  
endmodule