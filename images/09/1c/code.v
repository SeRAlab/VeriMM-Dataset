module voltage_sensor (
    input [3:0] voltage_in,
    output reg voltage_ok
);
    always @(*) begin
        if (voltage_in > 4'b0011) // 3 in binary
            voltage_ok = 1'b1;    // Voltage is above threshold
        else
            voltage_ok = 1'b0;    // Voltage is below threshold
    end
endmodule