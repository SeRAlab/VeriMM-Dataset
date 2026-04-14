module fan_speed_controller (
    input clk,
    input [7:0] temperature,  // Temperature input in degrees Celsius
    output reg low_speed,
    output reg medium_speed,
    output reg high_speed
);
    
    always @(posedge clk) begin
        if (temperature < 20) begin
            low_speed <= 1;
            medium_speed <= 0;
            high_speed <= 0;
        end else if (temperature >= 20 && temperature <= 30) begin
            low_speed <= 0;
            medium_speed <= 1;
            high_speed <= 0;
        end else begin
            low_speed <= 0;
            medium_speed <= 0;
            high_speed <= 1;
        end
    end
endmodule