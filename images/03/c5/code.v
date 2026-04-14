module thermal_sensor_calibration(  
    input [4:0] raw_temp,  
    output reg [4:0] calibrated_temp  
);  
    parameter OFFSET = 5'd2;  
    always @(*) begin  
        if (raw_temp + OFFSET > 5'd31)  
            calibrated_temp = 5'd31;  
        else  
            calibrated_temp = raw_temp + OFFSET;  
    end  
endmodule