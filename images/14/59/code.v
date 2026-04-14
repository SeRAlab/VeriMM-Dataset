module temperature_sensor_controller(
    input [3:0] temperature,
    output reg [2:0] warning_level
);
    always @(*) begin
        if (temperature < 5) 
            warning_level = 3'b000; // Below 5°C
        else if (temperature < 10) 
            warning_level = 3'b001; // 5°C to 9°C
        else if (temperature < 15) 
            warning_level = 3'b010; // 10°C to 14°C
        else 
            warning_level = 3'b011; // 15°C and above
    end
endmodule