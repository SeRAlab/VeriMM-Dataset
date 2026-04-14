module adc_8bit (
    input [2:0] voltage_level,
    output reg [7:0] digital_output
);
    always @(*) begin
        case (voltage_level)
            3'b000: digital_output = 8'd0;
            3'b001: digital_output = 8'd32;
            3'b010: digital_output = 8'd64;
            3'b011: digital_output = 8'd96;
            3'b100: digital_output = 8'd128;
            3'b101: digital_output = 8'd160;
            3'b110: digital_output = 8'd192;
            3'b111: digital_output = 8'd224;
            default: digital_output = 8'd0; // Default case
        endcase
    end
endmodule