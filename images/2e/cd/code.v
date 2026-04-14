module rsa_encrypt(  
    input clk,  
    input rst,  
    input [15:0] plaintext,  
    input [15:0] e,  
    input [15:0] n,  
    output reg [15:0] ciphertext,  
    output reg done  
);  
    reg [15:0] current_value;  
    reg [15:0] exponent;  
    reg [15:0] result;  
    reg [3:0] state;  

    localparam IDLE = 4'd0,  
               PROCESS = 4'd1,  
               DONE = 4'd2;  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            state <= IDLE;  
            ciphertext <= 0;  
            done <= 0;  
            current_value <= 0;  
            exponent <= 0;  
            result <= 1;  
        end else begin  
            case (state)  
                IDLE: begin  
                    current_value <= plaintext;  
                    exponent <= e;  
                    state <= PROCESS;  
                end  
                PROCESS: begin  
                    if (exponent > 0) begin  
                        if (exponent[0] == 1) begin  
                            result <= (result * current_value) % n;  
                        end  
                        current_value <= (current_value * current_value) % n;  
                        exponent <= exponent >> 1;  
                    end else begin  
                        ciphertext <= result;  
                        done <= 1;  
                        state <= DONE;  
                    end  
                end  
                DONE: begin  
                    // Stay in DONE state until reset  
                end  
            endcase  
        end  
    end  
endmodule