module RSA_Encryptor (  
    input clk,  
    input reset,  
    input [15:0] plaintext,  
    input [15:0] e,  
    input [15:0] n,  
    output reg [15:0] ciphertext,  
    output reg ready  
);  
    reg [15:0] temp;  
    reg [3:0] state;  

    localparam IDLE = 4'b0000,  
               CALCULATE = 4'b0001,  
               DONE = 4'b0010;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            state <= IDLE;  
            ready <= 0;  
            ciphertext <= 0;  
        end else begin  
            case (state)  
                IDLE: begin  
                    if (plaintext != 0) begin  
                        temp <= plaintext;  
                        state <= CALCULATE;  
                    end  
                end  
                CALCULATE: begin  
                    // Simple exponentiation (not optimized, for demo purposes)  
                    ciphertext <= (temp ** e) % n;  
                    state <= DONE;  
                end  
                DONE: begin  
                    ready <= 1;  
                    state <= IDLE;  
                end  
            endcase  
        end  
    end  
endmodule