module dac_24bit(  
    input [23:0] digital_input,  
    output reg [31:0] analog_output  
);  
    always @(*) begin  
        if (digital_input > 24'hFFFFFF)  
            analog_output = 32'd1000000;  
        else  
            analog_output = (digital_input * 32'd1000000) / 24'hFFFFFF;  
    end  
endmodule