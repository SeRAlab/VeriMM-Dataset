module adc_encoder (
    input [15:0] adc_value,
    output reg [7:0] encoded_value
);
    always @(*) begin
        if (adc_value < 256) begin
            encoded_value = adc_value[7:0];
        end else if (adc_value < 512) begin
            encoded_value = adc_value[7:0] - 8'd256;
        end else begin
            encoded_value = 8'd255;
        end
    end
endmodule