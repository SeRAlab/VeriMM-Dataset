module aes_8bit (  
    input wire clk,  
    input wire rst,  
    input wire start,  
    input wire [7:0] plaintext,  
    input wire [7:0] key,  
    output reg [7:0] ciphertext,  
    output reg done  
);  
    // AES round constants and simple example transformation  
    reg [7:0] state;  
    parameter ROUNDS = 1;  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            state <= 8'b0;  
            ciphertext <= 8'b0;  
            done <= 0;  
        end else if (start) begin  
            state <= plaintext ^ key;  // Example operation for AES  
            // Normally multiple rounds of transformation would happen here  
            ciphertext <= state;  
            done <= 1;  
        end  
    end  
endmodule