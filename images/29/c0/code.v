module adc_8bit (
    input [2:0] voltage_input,
    output reg [7:0] digital_output
);

always @(*) begin
    case (voltage_input)
        3'b000: digital_output = 8'h00; // 0
        3'b001: digital_output = 8'h33; // 1
        3'b010: digital_output = 8'h66; // 2
        3'b011: digital_output = 8'h99; // 3
        3'b100: digital_output = 8'hCC; // 4
        3'b101: digital_output = 8'hFF; // 5
        3'b110: digital_output = 8'hFF; // 6
        3'b111: digital_output = 8'hFF; // 7
        default: digital_output = 8'h00; // default case
    endcase
end
endmodule