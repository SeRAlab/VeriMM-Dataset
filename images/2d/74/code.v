module HMAC (  
    input clk,  
    input reset,  
    input [127:0] key,  
    input [127:0] message,  
    input start,  
    output reg [127:0] mac,  
    output reg done  
);  
    reg [127:0] inner_hash;  
    reg [127:0] outer_hash;  
    reg [127:0] ipad, opad;  
    reg [3:0] state;  
    
    initial begin  
        ipad = 128'h36363636363636363636363636363636;  
        opad = 128'h5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c;  
        state = 0;  
        done = 0;  
    end  
    
    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            mac <= 0;  
            done <= 0;  
            state <= 0;  
        end else begin  
            case (state)  
                0: begin  
                    if (start) begin  
                        inner_hash <= key ^ ipad;  
                        inner_hash <= inner_hash ^ message;  
                        state <= 1;  
                    end  
                end  
                1: begin  
                    outer_hash <= key ^ opad;  
                    outer_hash <= outer_hash ^ inner_hash;  
                    mac <= outer_hash;  
                    done <= 1;  
                    state <= 2;  
                end  
                2: begin  
                    done <= 0;  
                    state <= 0;  
                end  
            endcase  
        end  
    end  
endmodule