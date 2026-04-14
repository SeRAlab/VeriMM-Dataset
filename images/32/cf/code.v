module thermal_sensor_calibration (  
    input clk,  
    input reset,  
    input [7:0] temperature_in,  
    output reg [7:0] calibrated_temperature,  
    output reg needs_calibration  
);  

    // Calibration thresholds  
    parameter THRESHOLD_HIGH = 8'd75;  
    parameter THRESHOLD_LOW = 8'd15;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            calibrated_temperature <= 8'b0;  
            needs_calibration <= 1'b0;  
        end else begin  
            calibrated_temperature <= temperature_in;  
            if (temperature_in > THRESHOLD_HIGH || temperature_in < THRESHOLD_LOW)  
                needs_calibration <= 1'b1;  
            else  
                needs_calibration <= 1'b0;  
        end  
    end  
endmodule