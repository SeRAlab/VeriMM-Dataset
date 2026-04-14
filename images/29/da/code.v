module adc_processor (
    input [23:0] adc_input,
    output reg [7:0] digital_output
);
    always @(*) begin
        if (adc_input[23:16] > 8'd0) begin
            if (adc_input[7:0] > 8'd128) begin
                digital_output = adc_input[7:0];
            end else begin
                digital_output = 8'b00000000;
            end
        end else begin
            digital_output = 8'b00000000;
        end
    end
endmodule