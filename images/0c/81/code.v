module thermal_sensor_calibration(  
    input [2:0] raw_temp,  
    output reg [3:0] calibrated_temp  
);  
    always @* begin  
        if (raw_temp < 3'd4)  
            calibrated_temp = raw_temp + 4'd2;  
        else  
            calibrated_temp = raw_temp - 3'd1;  
    end  
endmodule