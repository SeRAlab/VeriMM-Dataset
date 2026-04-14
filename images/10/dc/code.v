module aes_8bit (  
    input clock,  
    input reset,  
    input [7:0] plaintext,  
    input [7:0] key,  
    output reg [7:0] ciphertext  
);  

    reg [7:0] round_key;  
    reg [7:0] state;  

    // Key expansion  
    always @(posedge clock or posedge reset) begin  
        if (reset) begin  
            round_key <= 8'h00;  
        end else begin  
            round_key <= key;  
        end  
    end  

    // AES round function (very simplified)  
    always @(posedge clock or posedge reset) begin  
        if (reset) begin  
            state <= 8'h00;  
            ciphertext <= 8'h00;  
        end else begin  
            // Substitution (using a simple direct mapping for simplification)  
            state <= {plaintext[6:0], plaintext[7]} ^ round_key;  
            // Permutation (dummy operation for simplicity)  
            ciphertext <= {state[1:0], state[7:2]} ^ round_key;  
        end  
    end  
endmodule