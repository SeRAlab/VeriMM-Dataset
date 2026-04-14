module qr_decomposition (  
    input [15:0] a11, a12,  
    input [15:0] a21, a22,  
    output reg [15:0] q11, q12,  
    output reg [15:0] q21, q22,  
    output reg [15:0] r11, r12,  
    output reg [15:0] r21, r22  
);  
    reg [15:0] norm_a1;  
    reg [15:0] norm_a2;  
    reg [15:0] dot_product;  
    always @(*) begin  
        norm_a1 = a11 * a11 + a21 * a21;  
        norm_a1 = norm_a1 ** (1/2);  
        q11 = a11 / norm_a1;  
        q21 = a21 / norm_a1;  
        
        dot_product = q11 * a12 + q21 * a22;  
        r11 = norm_a1;  
        r12 = dot_product;  
        
        norm_a2 = a12 * a12 + a22 * a22 - dot_product * dot_product;  
        norm_a2 = norm_a2 ** (1/2);  
        q12 = (a12 - dot_product * q11) / norm_a2;  
        q22 = (a22 - dot_product * q21) / norm_a2;  
        
        r21 = norm_a2;  
        r22 = 0;  
    end  
endmodule