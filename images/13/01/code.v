module adc_decoder (
    input [23:0] adc_input,
    output reg [3:0] range_out
);
    always @(*) begin
        if (adc_input > 255)
            range_out = 4'b1111;
        else
            range_out = adc_input[5:2]; // mapping input to output range
    end
endmodule