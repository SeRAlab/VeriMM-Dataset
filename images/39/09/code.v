module thermal_sensor_calibration(  
    input [9:0] temp_in,  
    input [9:0] cal_val,  
    output [9:0] temp_out  
);  
    assign temp_out = (temp_in + cal_val) & 10'b1111111111;  
endmodule