module dac_8bit (
    input [2:0] control,  // 3-bit control signal
    output reg [7:0] voltage  // 8-bit output voltage level
);
    always @(*) begin
        case (control)
            3'b000: voltage = 8'd0;     // 0V
            3'b001: voltage = 8'd32;    // 32V
            3'b010: voltage = 8'd64;    // 64V
            3'b011: voltage = 8'd96;    // 96V
            3'b100: voltage = 8'd128;   // 128V
            3'b101: voltage = 8'd160;   // 160V
            3'b110: voltage = 8'd192;   // 192V
            3'b111: voltage = 8'd255;   // 255V
            default: voltage = 8'd0;     // Default case
        endcase
    end
endmodule