module encoder_4to2 (  
    input wire I3,  
    input wire I2,  
    input wire I1,  
    input wire I0,  
    output reg [1:0] Y  
);  
    always @(*) begin  
        if (I3)  
            Y = 2'b11;  
        else if (I2)  
            Y = 2'b10;  
        else if (I1)  
            Y = 2'b01;  
        else if (I0)  
            Y = 2'b00;  
        else  
            Y = 2'b00;  
    end  
endmodule