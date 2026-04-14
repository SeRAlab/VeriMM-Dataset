module aes_fsm (  
    input clk,  
    input rst,  
    input start,  
    input [127:0] data_in,  
    input [127:0] key_in,  
    output reg [127:0] data_out,  
    output reg done  
);  
    reg [2:0] state;  
    reg [127:0] state_data;  
    reg [127:0] expanded_key;  
    
    parameter IDLE = 3'b000;  
    parameter KEY_EXPANSION = 3'b001;  
    parameter INITIAL_ROUND = 3'b010;  
    parameter ROUND1 = 3'b011;  
    parameter ROUND2 = 3'b100;  
    
    // Simplified key expansion  
    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            state <= IDLE;  
            done <= 0;  
        end else begin  
            case (state)  
                IDLE: begin  
                    if (start) begin  
                        state <= KEY_EXPANSION;  
                        state_data <= data_in;  
                        expanded_key <= key_in;  
                    end  
                end  
                KEY_EXPANSION: begin  
                    // Assume expanded_key is computed here  
                    state <= INITIAL_ROUND;  
                end  
                INITIAL_ROUND: begin  
                    // Assume initial round transformation  
                    state_data <= state_data ^ expanded_key;  
                    state <= ROUND1;  
                end  
                ROUND1: begin  
                    // Assume round transformation  
                    state_data <= state_data ^ expanded_key;  
                    state <= ROUND2;  
                end  
                ROUND2: begin  
                    // Final transformation  
                    data_out <= state_data ^ expanded_key;  
                    done <= 1;  
                    state <= IDLE;  
                end  
            endcase  
        end  
    end  
endmodule