module priority_encoder(  
    input [3:0] I,  
    output reg [1:0] O  
);  
    always @(*) begin  
        case (I)  
            4'b0000: O = 2'b00;  
            4'b0001: O = 2'b00;  
            4'b0010: O = 2'b01;  
            4'b0011: O = 2'b01;  
            4'b0100: O = 2'b10;  
            4'b0101: O = 2'b10;  
            4'b0110: O = 2'b10;  
            4'b0111: O = 2'b10;  
            4'b1000: O = 2'b11;  
            4'b1001: O = 2'b11;  
            4'b1010: O = 2'b11;  
            4'b1011: O = 2'b11;  
            4'b1100: O = 2'b11;  
            4'b1101: O = 2'b11;  
            4'b1110: O = 2'b11;  
            4'b1111: O = 2'b11;  
            default: O = 2'b00;  
        endcase  
    end  
endmodule