module aes_encrypt (  
    input wire clk,  
    input wire [127:0] plaintext,  
    input wire [127:0] key,  
    output reg [127:0] ciphertext  
);  
    reg [127:0] state;  

    always @(posedge clk) begin  
        state <= plaintext ^ key;  
        ciphertext <= state;  
    end  
endmodule