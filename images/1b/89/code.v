module voltage_sensor (
    input [2:0] voltage_input,
    output reg in_range
);
    always @(*) begin
        if (voltage_input >= 3'b100 && voltage_input <= 3'b101) 
            in_range = 1'b1;  // Voltage is in range
        else 
            in_range = 1'b0;  // Voltage is out of range
    end
endmodule