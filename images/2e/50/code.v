module simple_des_encryption(  
    input wire [63:0] plaintext,  
    input wire [63:0] key,  
    input wire clk,  
    output reg [63:0] ciphertext  
);  
    always @(posedge clk) begin  
        ciphertext <= plaintext ^ key;  
    end  
endmodule