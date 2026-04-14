module simple_des_encryption(  
    input clk,  
    input [7:0] plaintext,  
    input [7:0] key,  
    output reg [7:0] ciphertext  
);  
    always @(posedge clk) begin  
        ciphertext <= plaintext ^ key;  
    end  
endmodule