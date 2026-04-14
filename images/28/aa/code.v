module VCO (  
    input wire clk,  
    input wire [3:0] control_voltage,  
    output reg [7:0] frequency_out  
);  
    parameter MAX_FREQ = 255;  
    parameter MIN_FREQ = 0;  
    parameter VOLTAGE_RANGE = 15; // 4-bit control voltage range  
   
    always @(posedge clk) begin  
        frequency_out <= (control_voltage * (MAX_FREQ - MIN_FREQ)) / VOLTAGE_RANGE + MIN_FREQ;  
    end  
endmodule