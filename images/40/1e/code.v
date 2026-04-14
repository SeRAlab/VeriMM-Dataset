module temperature_sensor (
    input clk,
    input reset,
    input [3:0] temperature,
    output reg [2:0] warning
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            warning <= 3'b000;
        end else begin
            case (temperature)
                4'b0000: warning <= 3'b000; // 0C
                4'b0001: warning <= 3'b000; // 1C
                4'b0010: warning <= 3'b000; // 2C
                4'b0011: warning <= 3'b000; // 3C
                4'b0100: warning <= 3'b000; // 4C
                4'b0101: warning <= 3'b000; // 5C
                4'b0110: warning <= 3'b000; // 6C
                4'b0111: warning <= 3'b000; // 7C
                4'b1000: warning <= 3'b000; // 8C
                4'b1001: warning <= 3'b000; // 9C
                4'b1010: warning <= 3'b000; // 10C
                4'b1011: warning <= 3'b000; // 11C
                4'b1100: warning <= 3'b000; // 12C
                4'b1101: warning <= 3'b000; // 13C
                4'b1110: warning <= 3'b000; // 14C
                4'b1111: warning <= 3'b000; // 15C
                default: warning <= 3'b000;
            endcase
            
            if (temperature >= 4'b00010100 && temperature <= 4'b00011100) begin
                warning <= 3'b001; // Caution
            end else if (temperature >= 4'b00011101 && temperature <= 4'b00101000) begin
                warning <= 3'b010; // Warning
            end else if (temperature > 4'b00101000) begin
                warning <= 3'b011; // Danger
            end
        end
    end
endmodule