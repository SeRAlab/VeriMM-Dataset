module simple_DES(  
    input [63:0] plaintext,  
    input [63:0] key,  
    input clk,  
    input rst,  
    output reg [63:0] ciphertext  
);  
    // Internal registers for the encryption process  
    reg [63:0] temp;  
    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            ciphertext <= 64'b0;  
        end else begin  
            // Simple operation for the sake of this example  
            temp <= plaintext ^ key; // XOR operation  
            ciphertext <= temp;  
        end  
    end  
endmodule