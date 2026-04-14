module adc_converter (
    input [7:0] adc_input,
    input enable,
    output reg [3:0] upper_half,
    output reg [3:0] lower_half
);
    always @(*) begin
        if (enable) begin
            upper_half = adc_input[7:4]; // Most significant 4 bits
            lower_half = adc_input[3:0]; // Least significant 4 bits
        end else begin
            upper_half = 4'b0000;
            lower_half = 4'b0000;
        end
    end
endmodule