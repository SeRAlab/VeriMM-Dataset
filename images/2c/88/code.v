module thermal_sensor_calibration(  
    input [9:0] temperature_in,  
    output reg [9:0] temperature_out  
);  
    always @(*) begin  
        if (temperature_in < 10'd100)  
            temperature_out = temperature_in;  
        else  
            temperature_out = temperature_in - 10'd10;  
    end  
endmodule