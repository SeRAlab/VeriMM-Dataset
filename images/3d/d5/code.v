module adc_24bit_mux (
    input [23:0] input0,
    input [23:0] input1,
    input [23:0] input2,
    input [1:0] select,
    output reg [23:0] output_value
);
    parameter THRESHOLD = 24'hFFFFFF; // Error threshold
    parameter ERROR_VALUE = 24'hFFFFFF; // Error output value

    always @(*) begin
        case (select)
            2'b00: output_value = (input0 > THRESHOLD) ? ERROR_VALUE : input0;
            2'b01: output_value = (input1 > THRESHOLD) ? ERROR_VALUE : input1;
            2'b10: output_value = (input2 > THRESHOLD) ? ERROR_VALUE : input2;
            default: output_value = ERROR_VALUE; // Default case handling
        endcase
    end
endmodule