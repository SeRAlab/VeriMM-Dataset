module voltage_sensor (
    input [4:0] voltage_level,
    output reg above_threshold,
    output reg high_voltage
);

always @(*) begin
    if (voltage_level > 5'd20) begin
        above_threshold = 1;
        high_voltage = 1;
    end else begin
        above_threshold = 0;
        high_voltage = 0;
    end
end

endmodule