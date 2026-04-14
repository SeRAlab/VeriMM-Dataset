module dac_16bit (
    input [15:0] digital_input,
    output reg [11:0] pwm_output
);
    parameter REAL_REF_VOLTAGE = 3.3;
    parameter MAX_DAC_VALUE = 65535; // 2^16 - 1
    parameter MAX_PWM_VALUE = 4095; // 2^12 - 1

    always @(*) begin
        // Scale the 16-bit digital input to a 12-bit PWM output
        pwm_output = (digital_input * MAX_PWM_VALUE) / MAX_DAC_VALUE;
    end
endmodule