module ADC_Controller (
    input wire clk,
    input wire [7:0] control,
    input wire [23:0] adc_input,
    input wire valid,
    output reg [23:0] adc_output
);
    always @(posedge clk) begin
        if (valid) begin
            adc_output <= adc_input; // Simulate ADC conversion
        end
    end
endmodule