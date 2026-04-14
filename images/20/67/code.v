module convolutional_encoder(  
    input clk,  
    input rst,  
    input bit_in,  
    output reg [1:0] bit_out  
);  
    reg [1:0] state;  
    reg [1:0] next_state;  

    always @(posedge clk or posedge rst) begin  
        if (rst)  
            state <= 2'b00;  
        else  
            state <= next_state;  
    end  

    always @* begin  
        case (state)  
            2'b00: begin  
                if (bit_in) begin  
                    bit_out = 2'b11;  
                    next_state = 2'b10;  
                end else begin  
                    bit_out = 2'b00;  
                    next_state = 2'b00;  
                end  
            end  
            2'b01: begin  
                if (bit_in) begin  
                    bit_out = 2'b10;  
                    next_state = 2'b11;  
                end else begin  
                    bit_out = 2'b01;  
                    next_state = 2'b01;  
                end  
            end  
            2'b10: begin  
                if (bit_in) begin  
                    bit_out = 2'b01;  
                    next_state = 2'b00;  
                end else begin  
                    bit_out = 2'b10;  
                    next_state = 2'b01;  
                end  
            end  
            2'b11: begin  
                if (bit_in) begin  
                    bit_out = 2'b00;  
                    next_state = 2'b10;  
                end else begin  
                    bit_out = 2'b11;  
                    next_state = 2'b11;  
                end  
            end  
            default: begin  
                bit_out = 2'b00;  
                next_state = 2'b00;  
            end  
        endcase  
    end  
endmodule