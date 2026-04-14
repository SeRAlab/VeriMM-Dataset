module encoder_4to2 (  
    input [3:0] in,  
    output reg [1:0] out  
);  
    always @(*) begin  
        case (in)  
            4'b0000: out = 2'b00;  
            4'b0001: out = 2'b00;  
            4'b0010: out = 2'b01;  
            4'b0100: out = 2'b10;  
            4'b1000: out = 2'b11;  
            4'b0011: out = 2'b01; // if both 0 and 1 are high, output should be 01  
            4'b0110: out = 2'b10; // if both 2 and 1 are high, output should be 10  
            4'b1100: out = 2'b11; // if both 3 and 2 are high, output should be 11  
            default: out = 2'b00;  
        endcase  
    end  
endmodule