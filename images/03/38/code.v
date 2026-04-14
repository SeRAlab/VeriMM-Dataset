module viterbi_decoder(  
    input clk,  
    input [1:0] in_bits,  
    output reg [1:0] out_bits  
);  
    reg [2:0] state;  
    reg [2:0] next_state;  

    always @(posedge clk) begin  
        state <= next_state;  
    end  

    always @(*) begin  
        case(state)  
            3'b000: begin  
                out_bits = 2'b00;  
                if(in_bits == 2'b00) next_state = 3'b000;  
                else if(in_bits == 2'b01) next_state = 3'b001;  
                else if(in_bits == 2'b10) next_state = 3'b010;  
                else next_state = 3'b011;  
            end  
            3'b001: begin  
                out_bits = 2'b01;  
                if(in_bits == 2'b00) next_state = 3'b100;  
                else if(in_bits == 2'b01) next_state = 3'b000;  
                else if(in_bits == 2'b10) next_state = 3'b011;  
                else next_state = 3'b110;  
            end  
            3'b010: begin  
                out_bits = 2'b10;  
                if(in_bits == 2'b00) next_state = 3'b101;  
                else if(in_bits == 2'b01) next_state = 3'b110;  
                else if(in_bits == 2'b10) next_state = 3'b000;  
                else next_state = 3'b111;  
            end  
            default: begin  
                out_bits = 2'b11;  
                next_state = 3'b000;  
            end  
        endcase  
    end  
endmodule