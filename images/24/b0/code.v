module viterbi_decoder (  
    input clk,  
    input reset,  
    input [2:0] received_symbol,  
    output reg [1:0] decoded_output  
);  

    reg [2:0] state;  
    reg [2:0] next_state;  

    // State encoding  
    parameter S0 = 3'b000;  
    parameter S1 = 3'b001;  
    parameter S2 = 3'b010;  
    parameter S3 = 3'b011;  
    parameter S4 = 3'b100;  
    parameter S5 = 3'b101;  
    parameter S6 = 3'b110;  
    parameter S7 = 3'b111;  

    // Output logic based on state  
    always @(state) begin  
        case (state)  
            S0: decoded_output = 2'b00;  
            S1: decoded_output = 2'b01;  
            S2: decoded_output = 2'b10;  
            S3: decoded_output = 2'b11;  
            S4: decoded_output = 2'b00;  
            S5: decoded_output = 2'b01;  
            S6: decoded_output = 2'b10;  
            S7: decoded_output = 2'b11;  
            default: decoded_output = 2'b00;  
        endcase  
    end  

    // State transition logic  
    always @(posedge clk or posedge reset) begin  
        if (reset)  
            state <= S0;  
        else  
            state <= next_state;  
    end  

    // Next state logic  
    always @(*) begin  
        case (state)  
            S0: next_state = (received_symbol == 3'b000) ? S1 : S2;  
            S1: next_state = (received_symbol == 3'b001) ? S3 : S4;  
            S2: next_state = (received_symbol == 3'b010) ? S5 : S6;  
            S3: next_state = S7;  
            S4: next_state = S0;  
            S5: next_state = S1;  
            S6: next_state = S2;  
            S7: next_state = S3;  
            default: next_state = S0;  
        endcase  
    end  
endmodule