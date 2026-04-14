module viterbi_decoder(  
    input clk,  
    input rst,  
    input [1:0] encoded_bits,  
    output reg [1:0] decoded_bits,  
    output reg valid  
);  
    reg [1:0] state;  
    reg [1:0] next_state;  
    
    always @(posedge clk or posedge rst) begin  
        if (rst)  
            state <= 2'b00;  
        else  
            state <= next_state;  
    end  
    
    always @(*) begin  
        case (state)  
            2'b00: begin  
                if (encoded_bits == 2'b00) begin  
                    next_state = 2'b00;  
                    decoded_bits = 2'b00;  
                end else begin  
                    next_state = 2'b01;  
                    decoded_bits = 2'b01;  
                end  
            end  
            2'b01: begin  
                if (encoded_bits == 2'b10) begin  
                    next_state = 2'b10;  
                    decoded_bits = 2'b10;  
                end else begin  
                    next_state = 2'b11;  
                    decoded_bits = 2'b11;  
                end  
            end  
            2'b10: begin  
                next_state = 2'b00;  
                decoded_bits = 2'b00;  
            end  
            2'b11: begin  
                next_state = 2'b01;  
                decoded_bits = 2'b01;  
            end  
            default: begin  
                next_state = 2'b00;  
                decoded_bits = 2'b00;  
            end  
        endcase  
        valid = 1'b1;  
    end  
endmodule