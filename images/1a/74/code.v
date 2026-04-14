module viterbi_decoder(  
    input clk,  
    input rst,  
    input [1:0] input_bits,  
    output reg [1:0] decoded_bits,  
    output reg valid_output  
);  
    parameter STATE_WIDTH = 2;  
    parameter NUM_STATES = 4;  
    reg [STATE_WIDTH-1:0] state, next_state;  
    reg [1:0] path_metric [0:NUM_STATES-1];  
    integer i;  
   
    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            state <= 2'b00;  
            valid_output <= 0;  
            for (i = 0; i < NUM_STATES; i = i + 1)  
                path_metric[i] <= 2'b00;  
        end else begin  
            state <= next_state;  
        end  
    end  
   
    always @(*) begin  
        case (state)  
            2'b00: next_state = (input_bits == 2'b00) ? 2'b00 : 2'b01;  
            2'b01: next_state = (input_bits == 2'b10) ? 2'b10 : 2'b11;  
            2'b10: next_state = (input_bits == 2'b01) ? 2'b00 : 2'b01;  
            2'b11: next_state = (input_bits == 2'b11) ? 2'b10 : 2'b11;  
            default: next_state = 2'b00;  
        endcase  
    end  
   
    always @(posedge clk) begin  
        if (state == 2'b00 || state == 2'b10)  
            decoded_bits <= 2'b00;  
        else  
            decoded_bits <= 2'b11;  
        valid_output <= 1;  
    end  
endmodule