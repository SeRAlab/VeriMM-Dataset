module aes_round (  
    input clk,  
    input reset,  
    input [127:0] plaintext,  
    input [127:0] key,  
    output reg [127:0] ciphertext  
);  
    reg [127:0] round_key;  
    reg [127:0] state;  
      
    // Key expansion (for one round)  
    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            round_key <= 128'h0;  
        end else begin  
            round_key <= key;  // Simplified: Use the initial key as the round key  
        end  
    end  
      
    // AddRoundKey operation  
    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            state <= 128'h0;  
            ciphertext <= 128'h0;  
        end else begin  
            state <= plaintext ^ round_key; // Simple XOR operation  
            ciphertext <= state;  
        end  
    end  
endmodule