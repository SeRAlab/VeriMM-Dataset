module DAC_Controller (
    input [15:0] digital_input,
    output reg [11:0] analog_output
);
    
    parameter VREF = 4095; // 12-bit max value
    parameter MAX_DIGITAL = 65535; // 16-bit max value

    always @(*) begin
        analog_output = (digital_input * VREF) / MAX_DIGITAL; // Scale 16-bit input to 12-bit output
    end

endmodule