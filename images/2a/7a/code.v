module DES(input [63:0] plaintext, input [63:0] key, output reg [63:0] ciphertext, input clk, input rst);  
    // Internal states and variables  
    reg [63:0] L, R, newL, newR;  
    reg [63:0] roundKey;  

    // Initial state  
    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            L <= 64'd0;  
            R <= 64'd0;  
            ciphertext <= 64'd0;  
        end else begin  
            // Initial permutation  
            if (L == 0 && R == 0) begin  
                {L, R} <= {plaintext[63:32], plaintext[31:0]};  
            end else begin  
                // DES rounds  
                roundKey <= key; // Simplified for this example  
                newL <= R;  
                newR <= L ^ (R ^ roundKey); // F-function simplified  
                {L, R} <= {newL, newR};  
            end  
            // Final permutation  
            if (L != 0 || R != 0) begin  
                ciphertext <= {R, L};  
            end  
        end  
    end  
endmodule