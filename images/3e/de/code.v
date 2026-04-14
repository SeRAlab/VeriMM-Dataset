module adc_8bit (
    input [1:0] analog_input,
    output reg [7:0] digital_output
);
    always @(*) begin
        case (analog_input)
            2'b00: digital_output = 8'd0;     // 0
            2'b01: digital_output = 8'd85;    // 1/3 of 255
            2'b10: digital_output = 8'd170;   // 2/3 of 255
            2'b11: digital_output = 8'd255;   // 255
            default: digital_output = 8'd0;    // default case
        endcase
    end
endmodule