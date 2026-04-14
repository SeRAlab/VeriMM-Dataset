module rsa_encryption (  
    input clk,  
    input rst,  
    input [15:0] plaintext,  
    input [15:0] public_key,  
    input [15:0] modulus,  
    output reg [15:0] ciphertext,  
    output reg done  
);  
    reg [15:0] temp;  
    reg [3:0] state;  

    parameter IDLE = 4'b0000,  
              CALC = 4'b0001,  
              DONE = 4'b0010;  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            state <= IDLE;  
            ciphertext <= 16'b0;  
            done <= 0;  
        end else begin  
            case (state)  
                IDLE: begin  
                    if (plaintext != 0) begin  
                        temp <= plaintext;  
                        state <= CALC;  
                    end  
                end  
                CALC: begin  
                    // Simple iterative modular exponentiation  
                    ciphertext <= (temp ** public_key) % modulus;  
                    state <= DONE;  
                end  
                DONE: begin  
                    done <= 1;  
                    state <= IDLE;  
                end  
            endcase  
        end  
    end  
endmodule