module ADC_8bit (  
    input [2:0] voltage_level,  
    output reg [7:0] digital_output  
);  
    always @(*) begin  
        digital_output = voltage_level * 255 / 7;  
    end  
endmodule