module top_module(
    input [15:0] switch_input,
    input reset,
    output reg [7:0] red_led_output,
    output reg [7:0] green_led_output
);always @(*) begin
        if (reset) begin
            red_led_output <= 8'b0;
            green_led_output <= 8'b0;
        end else begin
            red_led_output <= ~switch_input[7:0];
            green_led_output <= ~switch_input[15:8];
        end
    end

endmodule