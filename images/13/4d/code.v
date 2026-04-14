module thermal_sensor_calibration (  
    input [7:0] sensor_input,  
    input [4:0] calibration_factor,  
    input clk,  
    input reset,  
    output reg [9:0] calibrated_output  
);  
    always @(posedge clk or posedge reset) begin  
        if (reset)  
            calibrated_output <= 10'b0;  
        else  
            calibrated_output <= (sensor_input * calibration_factor);  
    end  
endmodule