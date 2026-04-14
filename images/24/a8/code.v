module dvfs_controller(
    input [4:0] voltage,
    input clk,
    input reset,
    output reg [2:0] frequency
);

always @(posedge clk or posedge reset) begin
    if (reset) begin
        frequency <= 3'b000; // default to 0Hz on reset
    end else begin
        case (voltage)
            5'b00000: frequency <= 3'b000; // 0V
            5'b00001: frequency <= 3'b001; // 1V
            5'b00010: frequency <= 3'b010; // 2V
            5'b00011: frequency <= 3'b011; // 3V
            5'b00100: frequency <= 3'b100; // 4V
            5'b00101: frequency <= 3'b101; // 5V
            5'b00110: frequency <= 3'b110; // 6V
            5'b00111: frequency <= 3'b111; // 7V
            default:  frequency <= 3'b111; // Max frequency for > 7V
        endcase
    end
end
endmodule