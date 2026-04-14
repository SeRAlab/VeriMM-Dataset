module DAC_8bit (
    input [2:0] control,
    output reg [9:0] output_voltage
);
    always @(*) begin
        case (control)
            3'b000: output_voltage = 10'd0;       // 0V
            3'b001: output_voltage = 10'd19;      // 0.19V
            3'b010: output_voltage = 10'd38;      // 0.38V
            3'b011: output_voltage = 10'd57;      // 0.57V
            3'b100: output_voltage = 10'd76;      // 0.76V
            3'b101: output_voltage = 10'd95;      // 0.95V
            3'b110: output_voltage = 10'd114;     // 1.14V
            3'b111: output_voltage = 10'd133;     // 1.33V
            default: output_voltage = 10'd0;       // Default to 0V
        endcase
    end
endmodule