module thermal_sensor_calibration(  
    input wire clk,  
    input wire [7:0] input_temp,  // Input temperature (0 to 255 degrees Celsius)  
    input wire [7:0] cal_factor,   // Calibration factor (0 to 255)  
    output reg [7:0] output_temp   // Calibrated temperature  
);  
    always @(posedge clk) begin  
        output_temp <= input_temp + cal_factor;  
    end  
endmodule