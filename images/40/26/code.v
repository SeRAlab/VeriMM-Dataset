module viterbi_decoder(  
    input clk,  
    input rst,  
    input [1:0] symbol_in,  
    output reg [1:0] state_out  
);  
    reg [1:0] current_state, next_state;  
    parameter S0 = 2'b00, S1 = 2'b01, S2 = 2'b10, S3 = 2'b11;  

    always @(posedge clk or posedge rst) begin  
        if (rst)  
            current_state <= S0;  
        else  
            current_state <= next_state;  
    end  

    always @(*) begin  
        case (current_state)  
            S0: begin  
                if (symbol_in == 2'b00) next_state = S0;  
                else if (symbol_in == 2'b01) next_state = S1;  
                else if (symbol_in == 2'b10) next_state = S2;  
                else next_state = S3;  
            end  
            S1: begin  
                if (symbol_in == 2'b00) next_state = S0;  
                else if (symbol_in == 2'b01) next_state = S1;  
                else if (symbol_in == 2'b10) next_state = S2;  
                else next_state = S3;  
            end  
            S2: begin  
                if (symbol_in == 2'b00) next_state = S0;  
                else if (symbol_in == 2'b01) next_state = S1;  
                else if (symbol_in == 2'b10) next_state = S2;  
                else next_state = S3;  
            end  
            S3: begin  
                if (symbol_in == 2'b00) next_state = S0;  
                else if (symbol_in == 2'b01) next_state = S1;  
                else if (symbol_in == 2'b10) next_state = S2;  
                else next_state = S3;  
            end  
            default: next_state = S0;  
        endcase  
    end  

    always @(*) begin  
        state_out = current_state;  
    end  
endmodule