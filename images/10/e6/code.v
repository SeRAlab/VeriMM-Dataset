module thermal_sensor_calibration(  
    input wire clk,  
    input wire reset,  
    input wire [15:0] temp_input,  
    input wire [15:0] calibration_factor,  
    output reg [15:0] calibrated_temp  
);  

    always @(posedge clk or posedge reset) begin  
        if (reset)  
            calibrated_temp <= 16'b0;  
        else if (calibration_factor == 16'b0)  
            calibrated_temp <= temp_input;  
        else  
            calibrated_temp <= temp_input + calibration_factor;  
    end  
endmodule