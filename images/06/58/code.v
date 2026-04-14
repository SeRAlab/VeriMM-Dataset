module rsa_encryptor (  
    input clk,  
    input rst,  
    input [7:0] plaintext,  
    input start,  
    output reg [15:0] ciphertext,  
    output reg done  
);  
    reg [3:0] state;  
    reg [7:0] base;  
    reg [7:0] exp;  
    reg [15:0] mod;  
    reg [15:0] result;  
    reg [3:0] bit_index;  
    
    parameter IDLE = 4'b0000,  
              LOAD = 4'b0001,  
              CALC = 4'b0010,  
              DONE = 4'b0011;  
    
    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            state <= IDLE;  
            ciphertext <= 0;  
            done <= 0;  
            bit_index <= 0;  
            result <= 1;  
        end else begin  
            case (state)  
                IDLE: begin  
                    if (start) begin  
                        base <= plaintext;  
                        exp <= 7;  // Public exponent  
                        mod <= 13; // Modulus  
                        result <= 1;  
                        bit_index <= 0;  
                        state <= LOAD;  
                    end  
                end  
                LOAD: begin  
                    state <= CALC;  
                end  
                CALC: begin  
                    if (bit_index < 8) begin  
                        if (exp[bit_index]) begin  
                            result <= (result * base) % mod;  
                        end  
                        base <= (base * base) % mod;  
                        bit_index <= bit_index + 1;  
                    end else begin  
                        ciphertext <= result;  
                        done <= 1;  
                        state <= DONE;  
                    end  
                end  
                DONE: begin  
                    if (!start) begin  
                        done <= 0;  
                        state <= IDLE;  
                    end  
                end  
            endcase  
        end  
    end  
endmodule