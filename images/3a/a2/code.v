module aes_8bit (  
    input wire clk,  
    input wire reset,  
    input wire [7:0] plaintext,  
    input wire [7:0] key,  
    output reg [7:0] ciphertext  
);  

    reg [7:0] state;  
    reg [7:0] round_key;  

    // Simple S-Box for SubBytes (example values)
    reg [7:0] s_box [0:255];  
    initial begin  
        s_box[0] = 8'h63; s_box[1] = 8'h7c; s_box[2] = 8'h77; s_box[3] = 8'h7b;  
        // ... Initialize the remaining S-Box values here ...  
        s_box[254] = 8'h16; s_box[255] = 8'h00;  
    end  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            ciphertext <= 8'b0;  
        end else begin  
            // Simple round key addition
            round_key <= key;  
            state <= plaintext ^ round_key;  

            // SubBytes
            state <= s_box[state];  

            // ShiftRows (not applicable for 8-bit, we'll leave this step out)
            // MixColumns (simplified for 8-bit)
            ciphertext <= {state[6:0], state[7]} ^ round_key; // Simple representation  
        end  
    end  
endmodule