module encoder_4to2(  
    input wire I0,  
    input wire I1,  
    input wire I2,  
    input wire I3,  
    output reg O1,  
    output reg O0  
);  
    always @(*) begin  
        case ({I3, I2, I1, I0})  
            4'b0000: {O1, O0} = 2'b00;  
            4'b0001: {O1, O0} = 2'b00;  
            4'b0010: {O1, O0} = 2'b01;  
            4'b0011: {O1, O0} = 2'b01;  
            4'b0100: {O1, O0} = 2'b10;  
            4'b0101: {O1, O0} = 2'b10;  
            4'b0110: {O1, O0} = 2'b10;  
            4'b0111: {O1, O0} = 2'b10;  
            4'b1000: {O1, O0} = 2'b11;  
            4'b1001: {O1, O0} = 2'b11;  
            4'b1010: {O1, O0} = 2'b11;  
            4'b1011: {O1, O0} = 2'b11;  
            4'b1100: {O1, O0} = 2'b11;  
            4'b1101: {O1, O0} = 2'b11;  
            4'b1110: {O1, O0} = 2'b11;  
            4'b1111: {O1, O0} = 2'b11;  
            default: {O1, O0} = 2'b00;  
        endcase  
    end  
endmodule