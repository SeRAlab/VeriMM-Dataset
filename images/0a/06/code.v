module ThermalSensorCalibration (  
    input wire clk,  
    input wire reset,  
    input wire [7:0] temperature,  
    input wire [7:0] calibration_factor,  
    output reg [7:0] calibrated_temperature  
);  
    always @(posedge clk or posedge reset) begin  
        if (reset)  
            calibrated_temperature <= 8'b0;  
        else  
            calibrated_temperature <= temperature + calibration_factor;  
    end  
endmodule