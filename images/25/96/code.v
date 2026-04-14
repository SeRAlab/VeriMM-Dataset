module adc_8bit (
    input [2:0] control, // 3-bit control signal
    output reg [7:0] digital_out // 8-bit output
);
    always @(*) begin
        case (control)
            3'b000: digital_out = 8'b00000000; // Input 0
            3'b001: digital_out = 8'b00000001; // Input 1
            3'b010: digital_out = 8'b00000010; // Input 2
            3'b011: digital_out = 8'b00000011; // Input 3
            3'b100: digital_out = 8'b00000100; // Input 4
            3'b101: digital_out = 8'b00000101; // Input 5
            3'b110: digital_out = 8'b00000110; // Input 6
            3'b111: digital_out = 8'b00000111; // Input 7
            default: digital_out = 8'b00000000; // Default case
        endcase
    end
endmodule