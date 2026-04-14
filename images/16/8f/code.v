module temperature_sensor_controller(  
    input wire clk,  
    input wire reset,  
    input wire [3:0] temperature,  
    output reg high_temp_signal  
);  

always @(posedge clk or posedge reset) begin  
    if (reset) begin  
        high_temp_signal <= 0;  
    end else begin  
        if (temperature > 4'b1010) // 10 in binary  
            high_temp_signal <= 1;  
        else  
            high_temp_signal <= 0;  
    end  
end  
endmodule