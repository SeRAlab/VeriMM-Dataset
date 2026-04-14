module dac_controller (
    input [23:0] digital_input,
    input [23:0] threshold,
    output reg [23:0] analog_output,
    output reg valid
);
    always @(*) begin
        analog_output = digital_input;
        valid = (digital_input > threshold) ? 1'b1 : 1'b0;
    end
endmodule