module temperature_sensor_controller (  
    input wire clk,  
    input wire reset,  
    input wire [4:0] temperature,  
    output reg [1:0] warning_level  
);  
    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            warning_level <= 2'b00;  
        end else begin  
            if (temperature < 5'd20) begin  
                warning_level <= 2'b00; // Normal  
            end else if (temperature < 5'd30) begin  
                warning_level <= 2'b01; // Caution  
            end else if (temperature < 5'd40) begin  
                warning_level <= 2'b10; // Warning  
            end else begin  
                warning_level <= 2'b11; // Critical  
            end  
        end  
    end  
endmodule