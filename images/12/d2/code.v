module ADC_8bit (
    input [7:0] analog_in,
    output reg [7:0] digital_out
);
    parameter SCALING_FACTOR = 2;

    always @(*) begin
        if (analog_in * SCALING_FACTOR > 255)
            digital_out = 255;
        else
            digital_out = analog_in * SCALING_FACTOR;
    end
endmodule