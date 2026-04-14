module DVFS_Controller (  
    input [7:0] current_load,  
    input [7:0] desired_voltage,  
    input [7:0] desired_frequency,  
    output reg [7:0] adjusted_voltage,  
    output reg [7:0] adjusted_frequency  
);  
    parameter LOAD_THRESHOLD = 100; // Threshold for load  
    always @(*) begin  
        if (current_load > LOAD_THRESHOLD) begin  
            adjusted_voltage = desired_voltage - 10; // Decrease voltage  
            adjusted_frequency = desired_frequency - 10; // Decrease frequency  
        end else begin  
            adjusted_voltage = desired_voltage + 10; // Increase voltage  
            adjusted_frequency = desired_frequency + 10; // Increase frequency  
        end  
    end  
endmodule