module ThermalSensorCalibration(  
    input clk,  
    input reset,  
    input [11:0] raw_data,  
    input [7:0] calibration_factor,  
    output reg [15:0] calibrated_temperature  
);  
    reg [11:0] raw_data_reg;  
    reg [7:0] calibration_factor_reg;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            calibrated_temperature <= 16'b0;  
            raw_data_reg <= 12'b0;  
            calibration_factor_reg <= 8'b0;  
        end else begin  
            raw_data_reg <= raw_data;  
            calibration_factor_reg <= calibration_factor;  
            calibrated_temperature <= raw_data_reg * calibration_factor_reg;  
        end  
    end  
endmodule