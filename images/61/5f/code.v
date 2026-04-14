module top_module(
    input clk,
    input reset,
    input enable,
    input [7:0] count_to,
    output reg [3:0] leds
);reg [7:0] count_reg = 8'b0; // initialize count register to 0

    always @(posedge clk) begin
        if (reset) begin
            count_reg <= 8'b0; // reset count register to 0
            leds <= 4'b0; // reset LEDs to 0
        end else if (enable) begin
            count_reg <= count_reg + 1; // increment count register
            if (count_reg == count_to) begin
                count_reg <= 8'b0; // reset count register to 0
            end
        end
    end

    // assign LEDs to the binary value of the count register
    always @(*) begin
        case (count_reg)
            8'b0000_0000: leds <= 4'b0000;
            8'b0000_0001: leds <= 4'b0001;
            8'b0000_0010: leds <= 4'b0010;
            8'b0000_0011: leds <= 4'b0011;
            8'b0000_0100: leds <= 4'b0100;
            8'b0000_0101: leds <= 4'b0101;
            8'b0000_0110: leds <= 4'b0110;
            8'b0000_0111: leds <= 4'b0111;
            8'b0000_1000: leds <= 4'b1000;
            8'b0000_1001: leds <= 4'b1001;
            8'b0000_1010: leds <= 4'b1010;
            8'b0000_1011: leds <= 4'b1011;
            8'b0000_1100: leds <= 4'b1100;
            8'b0000_1101: leds <= 4'b1101;
            8'b0000_1110: leds <= 4'b1110;
            8'b0000_1111: leds <= 4'b1111;
            default: leds <= 4'b0000; // reset LEDs to 0 if count is out of range
        endcase
    end

endmodule