module voltage_sensor(
    input [2:0] voltage_level,
    output reg safe
);
    always @* begin
        if (voltage_level >= 3'b000 && voltage_level <= 3'b101) // 0V to 5V
            safe = 1'b1; // Safe
        else
            safe = 1'b0; // Not Safe
    end
endmodule