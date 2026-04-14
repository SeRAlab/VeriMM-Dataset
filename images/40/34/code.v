module adc_8bit(  
    input [2:0] voltage_level,  
    output reg [7:0] digital_out  
);  

    always @(*) begin  
        digital_out = voltage_level * 32;  
    end  
endmodule