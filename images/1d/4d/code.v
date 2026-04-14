module aes_8bit (  
    input [7:0] plaintext,  
    input [7:0] key,  
    input clk,  
    input rst,  
    output reg [7:0] ciphertext  
);  

reg [7:0] round_key;  
reg [7:0] state;  

// Key expansion  
always @(posedge clk or posedge rst) begin  
    if (rst) begin  
        round_key <= key;  
        state <= plaintext;  
        ciphertext <= 0;  
    end else begin  
        // Simple substitution (S-box and permutation can be implemented as combinational logic)  
        state <= (state ^ round_key); // AddRoundKey  
        round_key <= {round_key[6:0], round_key[7]}; // Rotate key for simplicity  
        ciphertext <= state;  
    end  
end  

endmodule