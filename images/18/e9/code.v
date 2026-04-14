module dot_product (  
    input [4:0] vec_a,  
    input [4:0] vec_b,  
    output reg [9:0] result  
);  
    always @(*) begin  
        result = vec_a[0] * vec_b[0] +  
                 vec_a[1] * vec_b[1] +  
                 vec_a[2] * vec_b[2] +  
                 vec_a[3] * vec_b[3] +  
                 vec_a[4] * vec_b[4];  
    end  
endmodule