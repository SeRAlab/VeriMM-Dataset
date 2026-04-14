module huffman_encoder(input [3:0] char, output reg [2:0] encoded);  
    always @(*) begin  
        case(char)  
            4'b0000: encoded = 3'b000;  
            4'b0001: encoded = 3'b001;  
            4'b0010: encoded = 3'b010;  
            4'b0011: encoded = 3'b011;  
            4'b0100: encoded = 3'b100;  
            4'b0101: encoded = 3'b101;  
            4'b0110: encoded = 3'b110;  
            4'b0111: encoded = 3'b111;  
            4'b1000: encoded = 3'b000;  
            4'b1001: encoded = 3'b001;  
            4'b1010: encoded = 3'b010;  
            4'b1011: encoded = 3'b011;  
            4'b1100: encoded = 3'b100;  
            4'b1101: encoded = 3'b101;  
            4'b1110: encoded = 3'b110;  
            4'b1111: encoded = 3'b111;  
            default: encoded = 3'bxxx;  
        endcase  
    end  
endmodule