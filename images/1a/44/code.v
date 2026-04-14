module adc_decoder(  
    input [23:0] adc_value,  
    output reg [2:0] range  
);  
    always @(*) begin  
        if (adc_value <= 24'h7FFFFF)  
            range = 3'b000; // Range 0  
        else if (adc_value <= 24'hFFFFFF)  
            range = 3'b001; // Range 1  
        else  
            range = 3'bxxx; // Invalid  
    end  
endmodule