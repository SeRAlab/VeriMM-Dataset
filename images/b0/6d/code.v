module top_module(
    input wire clk, reset, button,
    output reg [6:0] leds
);reg [3:0] digit = 0;

always @(posedge clk, posedge reset) begin
    if (reset) begin
        digit <= 0;
        leds <= 7'b0000001;
    end else if (button) begin
        digit <= digit + 1;
        case (digit)
            4'b0000: leds <= 7'b0000001; // 0
            4'b0001: leds <= 7'b1001111; // 1
            4'b0010: leds <= 7'b0010010; // 2
            4'b0011: leds <= 7'b0000110; // 3
            4'b0100: leds <= 7'b1001100; // 4
            4'b0101: leds <= 7'b0100100; // 5
            4'b0110: leds <= 7'b0100000; // 6
            4'b0111: leds <= 7'b0001111; // 7
            4'b1000: leds <= 7'b0000000; // 8
            4'b1001: leds <= 7'b0000100; // 9
            default: leds <= 7'b1111111; // default to all LEDs on
        endcase
    end
end

endmodule