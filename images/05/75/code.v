module aes_8bit (  
    input wire clk,  
    input wire [7:0] plaintext,  
    input wire [7:0] key,  
    output reg [7:0] ciphertext  
);  
    reg [7:0] state;  

    always @(posedge clk) begin  
        // Key addition  
        state <= plaintext ^ key;  
        // Simple mixing function (for demonstration purpose)  
        ciphertext <= {state[6:0], state[7]} ^ 8'h5A;  
    end  
endmodule