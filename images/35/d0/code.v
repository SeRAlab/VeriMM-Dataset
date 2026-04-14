module dac_controller(
    input [15:0] digital_input,
    input control,
    output reg [15:0] analog_output
);
    always @(*) begin
        if (control) begin
            analog_output = digital_input; // Output voltage corresponds to the digital input
        end else begin
            analog_output = 16'b0; // Hold output at zero if control is low
        end
    end
endmodule