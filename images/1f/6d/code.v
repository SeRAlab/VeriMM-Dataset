module rsa_transform (  
    input [9:0] a,  
    input [9:0] b,  
    output [9:0] encrypted_output  
);  
    wire [10:0] sum;  
    assign sum = a + b;  
    assign encrypted_output = sum % 17;  
endmodule