module ADC_8bit (  
    input [2:0] voltage_in, // 3-bit input represents 0-7 volts  
    output reg [7:0] digital_out // 8-bit digital output  
);  
    always @(*) begin  
        digital_out = voltage_in * 32; // Scale 0-7 to 0-255  
    end  
endmodule