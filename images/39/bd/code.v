module adc_comparator (
    input [15:0] adc_input,
    input [15:0] reference,
    output reg greater_than_ref,
    output reg [15:0] output_signal
);
    
    always @(*) begin
        if (adc_input > reference) begin
            greater_than_ref = 1'b1;
            output_signal = reference; // Output reference if input is greater
        end else begin
            greater_than_ref = 1'b0;
            output_signal = adc_input; // Output input if it is less than or equal
        end
    end
endmodule