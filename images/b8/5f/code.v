module top_module(
    input  wire       clk,
    input  wire       reset_n,
    input  wire [3:0] sw,
    input  wire [3:0] btn,
    output reg        led0_r,
    output reg        led0_g,
    output reg        led0_b,
    output reg        led1_r,
    output reg        led1_g,
    output reg        led1_b,
    output reg        led2_r,
    output reg        led2_g,
    output reg        led2_b,
    output reg        led3_r,
    output reg        led3_g,
    output reg        led3_b,
    output reg        led4,
    output reg        led5,
    output reg        led6,
    output reg        led7
);reg [3:0] led_val;

always @ (posedge clk or negedge reset_n) begin
    if (~reset_n) begin
        led_val <= 0;
        led0_r <= 0;
        led0_g <= 0;
        led0_b <= 0;
        led1_r <= 0;
        led1_g <= 0;
        led1_b <= 0;
        led2_r <= 0;
        led2_g <= 0;
        led2_b <= 0;
        led3_r <= 0;
        led3_g <= 0;
        led3_b <= 0;
        led4 <= 0;
        led5 <= 0;
        led6 <= 0;
        led7 <= 0;
    end else begin
        case(btn)
            4'b0001: led_val <= sw;
            4'b0010: led_val <= {sw[0], sw[1], sw[2], sw[3]};
            4'b0100: led_val <= {sw[2:0], sw[3]};
            4'b1000: led_val <= {sw[3], sw[2:0]};
            default: led_val <= led_val;
        endcase

        led0_r <= led_val[0];
        led0_g <= led_val[1];
        led0_b <= led_val[2];
        led1_r <= led_val[0];
        led1_g <= led_val[1];
        led1_b <= led_val[2];
        led2_r <= led_val[0];
        led2_g <= led_val[1];
        led2_b <= led_val[2];
        led3_r <= led_val[0];
        led3_g <= led_val[1];
        led3_b <= led_val[2];
        led4 <= led_val[3];
        led5 <= led_val[2];
        led6 <= led_val[1];
        led7 <= led_val[0];
    end
end

endmodule