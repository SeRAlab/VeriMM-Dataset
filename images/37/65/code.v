module voltage_sensor (
    input [4:0] voltage_input,
    output reg is_high
);
    parameter REF_VOLTAGE = 10;

    always @* begin
        if (voltage_input > REF_VOLTAGE) 
            is_high = 1;
        else 
            is_high = 0;
    end
endmodule