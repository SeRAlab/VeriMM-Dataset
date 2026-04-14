module viterbi_decoder (  
    input clk,  
    input reset,  
    input enable,  
    input [1:0] input_bits,  
    output reg [1:0] output_bits,  
    output reg done  
);  

    reg [1:0] state;  
    reg [1:0] next_state;  

    // State transition logic
    always @* begin  
        case(state)  
            2'b00: next_state = (input_bits == 2'b00) ? 2'b00 : 2'b01;  
            2'b01: next_state = (input_bits == 2'b00) ? 2'b10 : 2'b11;  
            2'b10: next_state = (input_bits == 2'b00) ? 2'b00 : 2'b01;  
            2'b11: next_state = (input_bits == 2'b00) ? 2'b10 : 2'b11;  
            default: next_state = 2'b00;  
        endcase  
    end  

    // Output generation logic
    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            state <= 2'b00;  
            output_bits <= 2'b00;  
            done <= 0;  
        end else if (enable) begin  
            state <= next_state;  
            output_bits <= next_state;  
            done <= 1;  
        end  
    end  
endmodule