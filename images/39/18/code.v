module adc_24bit (
    input [23:0] adc_input,
    input enable,
    output reg [23:0] adc_output
);
    
always @(*) begin
    if (enable) begin
        adc_output = adc_input >> 4; // Right shift by 4
    end else begin
        adc_output = 24'b0; // Output zero when not enabled
    end
end

endmodule