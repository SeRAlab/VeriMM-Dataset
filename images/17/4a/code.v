module adc_8bit (
    input wire [7:0] analog_input,
    input wire enable,
    output reg [7:0] digital_output
);
    always @(*) begin
        if (enable) begin
            digital_output = analog_input; // Convert analog input to digital output
        end
    end
endmodule