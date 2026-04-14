module LDO_Controller(
    input [2:0] voltage_in,  // 3-bit input voltage
    output reg reg_signal     // Regulation signal
);
    always @(*) begin
        if (voltage_in < 3'b010)  // Below threshold
            reg_signal = 1'b0;     // Turn off
        else if (voltage_in > 3'b100) // Above threshold
            reg_signal = 1'b0;     // Turn off
        else                        // Within range
            reg_signal = 1'b1;     // Turn on
    end
endmodule