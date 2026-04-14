module aes_8bit (  
    input wire [7:0] plaintext,  
    input wire [127:0] key,  
    input wire clk,  
    input wire start,  
    output reg [7:0] ciphertext,  
    output reg done  
);  
    reg [7:0] state;  
    reg [3:0] round;  
    
    always @(posedge clk) begin  
        if (start) begin  
            state <= plaintext ^ key[7:0]; // Key addition step  
            round <= 0;  
            done <= 0;  
        end else if (round < 10) begin  
            // Simplified substitution step (using a dummy substitution for example)  
            state <= {state[6:0], state[7]} ^ key[round*8 +: 8];  
            round <= round + 1;  
        end else begin  
            ciphertext <= state;  
            done <= 1;  
        end  
    end  
endmodule