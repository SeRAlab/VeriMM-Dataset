module aes_8bit (  
    input wire [7:0] plaintext,  
    input wire [7:0] key,  
    input wire clk,  
    output reg [7:0] ciphertext  
);  

    reg [7:0] round_key;  
    reg [7:0] state;  

    // Key expansion (for simplicity, we'll just use the key directly)  
    always @(posedge clk) begin  
        round_key <= key;  
        state <= plaintext ^ round_key; // Simple AddRoundKey step  
        ciphertext <= state; // Output the ciphertext  
    end  
endmodule