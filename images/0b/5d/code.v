module hmac #(parameter KEY_SIZE = 128, parameter MESSAGE_SIZE = 128, parameter HASH_SIZE = 128)  
(  
    input clk,  
    input rst,  
    input start,  
    input [KEY_SIZE-1:0] key,  
    input [MESSAGE_SIZE-1:0] message,  
    output reg [HASH_SIZE-1:0] hash,  
    output reg done  
);  
    reg [2:0] state;  
    localparam IDLE = 3'b000,  
               HASH1 = 3'b001,  
               HASH2 = 3'b010,  
               DONE = 3'b011;  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            state <= IDLE;  
            hash <= 0;  
            done <= 0;  
        end else begin  
            case (state)  
                IDLE: begin  
                    if (start) begin  
                        state <= HASH1;  
                        done <= 0;  
                    end  
                end  
                HASH1: begin  
                    hash <= key ^ message;  
                    state <= HASH2;  
                end  
                HASH2: begin  
                    hash <= hash ^ key;  
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