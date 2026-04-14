module switching_regulator (
    input wire [7:0] vin,     // input voltage (0-255)
    input wire [7:0] vref,    // reference voltage (0-255)
    output reg pwm            // PWM output
);
    
    always @(*) begin
        if (vin < vref)
            pwm = 1; // Turn on the switch
        else
            pwm = 0; // Turn off the switch
    end

endmodule