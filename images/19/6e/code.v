module aes_8bit_encryption(  
    input [7:0] plaintext,  
    input [127:0] key,  
    input clk,  
    input start,  
    output reg [7:0] ciphertext,  
    output reg done  
);  
    reg [7:0] state;  
    reg [3:0] round;  

    always @(posedge clk) begin  
        if (start) begin  
            state <= plaintext;  
            round <= 0;  
            done <= 0;  
        end else if (round < 10) begin  
            // Simple round transformation (substitution and permutation)  
            state <= {state[6:0], state[7]} ^ key[round*8 +: 8];  
            round <= round + 1;  
        end else if (round == 10) begin  
            ciphertext <= state;  
            done <= 1;  
        end  
    end  
endmodule