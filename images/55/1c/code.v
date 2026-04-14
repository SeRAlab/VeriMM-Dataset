module top_module(
    input clk,
    input reset,      // Synchronous active-high reset
    input [3:0] counter_out,  // 4-bit output from the counter
    input [1:0] mux_out,  // 2-bit output from the multiplexer
    output reg [7:0] led_out // 8-bit output controlling the LED rotation
);reg [1:0] blink_rate;

always @ (posedge clk) begin
    if (reset) begin
        blink_rate <= 2'b00;
    end else begin
        if (counter_out < 8) begin
            blink_rate <= mux_out[0];
        end else begin
            blink_rate <= mux_out[1];
        end
    end
end

reg [3:0] led_pos;

always @ (posedge clk) begin
    if (reset) begin
        led_pos <= 4'b0000;
    end else begin
        if (led_pos == 4'b1111) begin
            led_pos <= 4'b0000;
        end else begin
            led_pos <= led_pos + 1;
        end
    end
end

always @ (posedge clk) begin
    if (reset) begin
        led_out <= 8'b00000001;
    end else begin
        case (led_pos)
            4'b0000: led_out <= 8'b00000001;
            4'b0001: led_out <= 8'b00000010;
            4'b0010: led_out <= 8'b00000100;
            4'b0011: led_out <= 8'b00001000;
            4'b0100: led_out <= 8'b00010000;
            4'b0101: led_out <= 8'b00100000;
            4'b0110: led_out <= 8'b01000000;
            4'b0111: led_out <= 8'b10000000;
            4'b1000: led_out <= blink_rate ? 8'b11111111 : 8'b00000001;
            4'b1001: led_out <= blink_rate ? 8'b11111110 : 8'b00000010;
            4'b1010: led_out <= blink_rate ? 8'b11111100 : 8'b00000100;
            4'b1011: led_out <= blink_rate ? 8'b11111000 : 8'b00001000;
            4'b1100: led_out <= blink_rate ? 8'b11110000 : 8'b00010000;
            4'b1101: led_out <= blink_rate ? 8'b11100000 : 8'b00100000;
            4'b1110: led_out <= blink_rate ? 8'b11000000 : 8'b01000000;
            4'b1111: led_out <= blink_rate ? 8'b10000000 : 8'b10000000;
        endcase
    end
end

endmodule