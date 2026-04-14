module thermal_sensor_calibration(  
    input wire clk,  
    input wire rst,  
    input wire [7:0] temperature_in,  
    input wire [7:0] calibration_factor,  
    output reg [7:0] calibrated_temperature  
);  

    always @(posedge clk or posedge rst) begin  
        if (rst)  
            calibrated_temperature <= 8'd0;  
        else  
            calibrated_temperature <= temperature_in + calibration_factor;  
    end  
endmodule