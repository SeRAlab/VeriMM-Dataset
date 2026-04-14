module encoder_4to2 (  
    input wire I0,  
    input wire I1,  
    input wire I2,  
    input wire I3,  
    output reg Y0,  
    output reg Y1  
);  
    always @(*) begin  
        case ({I3, I2, I1, I0})  
            4'b0000: {Y1, Y0} = 2'b00;  
            4'b0001: {Y1, Y0} = 2'b00;  
            4'b0010: {Y1, Y0} = 2'b01;  
            4'b0011: {Y1, Y0} = 2'b01;  
            4'b0100: {Y1, Y0} = 2'b10;  
            4'b0101: {Y1, Y0} = 2'b10;  
            4'b0110: {Y1, Y0} = 2'b10;  
            4'b0111: {Y1, Y0} = 2'b10;  
            4'b1000: {Y1, Y0} = 2'b11;  
            4'b1001: {Y1, Y0} = 2'b11;  
            4'b1010: {Y1, Y0} = 2'b11;  
            4'b1011: {Y1, Y0} = 2'b11;  
            4'b1100: {Y1, Y0} = 2'b11;  
            4'b1101: {Y1, Y0} = 2'b11;  
            4'b1110: {Y1, Y0} = 2'b11;  
            4'b1111: {Y1, Y0} = 2'b11;  
            default: {Y1, Y0} = 2'b00;  
        endcase  
    end  
endmodule