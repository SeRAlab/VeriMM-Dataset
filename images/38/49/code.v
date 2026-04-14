module adc_processor (
    input [23:0] adc_input,
    input enable,
    output reg [7:0] adc_output
);
    always @(*) begin
        if (enable) begin
            adc_output = adc_input[23:16]; // output upper 8 bits
        end else begin
            adc_output = 8'b00000000; // output zero when not enabled
        end
    end
endmodule